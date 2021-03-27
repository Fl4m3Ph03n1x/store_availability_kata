defmodule Availabilities do
  @moduledoc """
  Calculates availability of stores.
  """

  alias Availabilities.{Availability, Params, Schedule, TimeSlotSettings}
  alias Timex

  ##############
  # Public API #
  ##############

  @doc """
  Returns the availability for a given store, or empty if the store is closed
  """
  @spec build(Params.t(), Date.t()) :: [Availability.t()] | {:error, :invalid_date}
  def build(%Params{schedules: schedules, settings: slots}, date),
    do:
      date
      |> Timex.weekday()
      |> num_to_weekday()
      |> select_store_open_days(schedules)
      |> build_slots(slots, date)
      |> handle_response()

  #################
  # Private funcs #
  #################

  @spec num_to_weekday(non_neg_integer | {:error, :invalid_date}) ::
          {:ok, Timex.weekday_name()} | {:error, :invalid_date}
  defp num_to_weekday(1), do: {:ok, :monday}
  defp num_to_weekday(2), do: {:ok, :tuesday}
  defp num_to_weekday(3), do: {:ok, :wednesday}
  defp num_to_weekday(4), do: {:ok, :thursday}
  defp num_to_weekday(5), do: {:ok, :friday}
  defp num_to_weekday(6), do: {:ok, :saturday}
  defp num_to_weekday(7), do: {:ok, :sunday}
  defp num_to_weekday(error), do: error

  @spec select_store_open_days({:ok, Timex.weekday_name()} | {:error, :invalid_date}, [
          Schedule.t()
        ]) :: {:ok, [Schedule.t()]} | {:error, :invalid_date}
  defp select_store_open_days({:ok, weekday}, schedules),
    do: {:ok, Enum.filter(schedules, &store_open?(weekday, &1))}

  defp select_store_open_days({:error, _reason} = error, _schedules), do: error

  @spec store_open?(Timex.weekday_name(), Schedule.t()) :: boolean
  defp store_open?(weekday, %Schedule{weekday: schedule_weekday}), do: weekday == schedule_weekday

  @spec build_slots(
          {:ok, [Schedule.t()]} | {:error, :invalid_date},
          TimeSlotSettings.t(),
          Date.t()
        ) :: {:ok, :store_closed} | {:ok, Availability.t()} | {:error, :invalid_date}
  defp build_slots({:ok, []}, _slots, _date), do: {:ok, :store_closed}

  defp build_slots(
         {:ok, [schedule]},
         %TimeSlotSettings{slot_recurrrence: recurrence, slot_duration: duration},
         date
       ) do
    start_time = schedule.start_time
    end_time = schedule.end_time

    {:ok,
     %Availability{
       weekday: schedule.weekday,
       date: date,
       slots: slots_in_schedule(start_time, end_time, recurrence, duration, start_time)
     }}
  end

  defp build_slots({:error, _reason} = error, _slots, _date), do: error

  @spec slots_in_schedule(Time.t(), Time.t(), non_neg_integer, non_neg_integer, Time.t(), [map]) ::
          [map]
  defp slots_in_schedule(start_time, end_time, recurrence, duration, current_time, slots \\ [])

  defp slots_in_schedule(start_time, end_time, recurrence, duration, current_time, slots)
       when current_time < end_time do
    slot = %{
      start_time: Time.truncate(current_time, :second),
      end_time: current_time |> Time.add(duration, :second) |> Time.truncate(:second)
    }

    new_slots = [slot | slots]

    slots_in_schedule(
      start_time,
      end_time,
      recurrence,
      duration,
      Time.add(current_time, recurrence, :second),
      new_slots
    )
  end

  defp slots_in_schedule(_start_time, end_time, _recurrence, _duration, current_time, slots)
       when current_time >= end_time,
       do: Enum.reverse(slots)

  @spec handle_response({:ok, :store_closed | Availability.t()} | {:error, any}) ::
          {:ok, [Availability.t()]} | {:error, any}
  defp handle_response({:ok, :store_closed}), do: []
  defp handle_response({:ok, data}), do: [data]
  defp handle_response(error), do: error
end
