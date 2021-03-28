defmodule Availabilities do
  @moduledoc """
  Calculates availability of stores.
  """

  alias Availabilities.{Availability, Params, Schedule, TimeSlotSettings}

  #########
  # Types #
  #########

  @typedoc """
  Day of the week in human friendly format.
  """
  @type weekday_name ::
          :monday | :tuesday | :wednesday | :thursday | :friday | :saturday | :sunday

  @typedoc """
  Represents a time slot. Time slots have a begining and an end, and the end must never be before
  its beginning.
  """
  @type time_slot :: %{
          start_time: Time.t(),
          end_time: Time.t()
        }

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
      |> Date.day_of_week()
      |> num_to_weekday()
      |> select_store_open_days(schedules)
      |> build_slots(slots, date)
      |> handle_response()

  #################
  # Private funcs #
  #################

  @spec num_to_weekday(non_neg_integer) :: weekday_name()
  defp num_to_weekday(1), do: :monday
  defp num_to_weekday(2), do: :tuesday
  defp num_to_weekday(3), do: :wednesday
  defp num_to_weekday(4), do: :thursday
  defp num_to_weekday(5), do: :friday
  defp num_to_weekday(6), do: :saturday
  defp num_to_weekday(7), do: :sunday

  @spec select_store_open_days(weekday_name(), [
          Schedule.t()
        ]) :: [Schedule.t()]
  defp select_store_open_days(weekday, schedules),
    do: Enum.filter(schedules, &store_open?(weekday, &1))

  @spec store_open?(weekday_name(), Schedule.t()) :: boolean
  defp store_open?(weekday, %Schedule{weekday: schedule_weekday}), do: weekday == schedule_weekday

  @spec build_slots(
          [Schedule.t()],
          TimeSlotSettings.t(),
          Date.t()
        ) :: :store_closed | Availability.t()
  defp build_slots([], _slots, _date), do: :store_closed

  defp build_slots(
         [schedule],
         %TimeSlotSettings{slot_recurrrence: recurrence, slot_duration: duration},
         date
       ) do
    start_time = schedule.start_time
    end_time = schedule.end_time

    %Availability{
      weekday: schedule.weekday,
      date: date,
      slots: slots_in_schedule(start_time, end_time, recurrence, duration, start_time)
    }
  end

  @spec slots_in_schedule(Time.t(), Time.t(), non_neg_integer, non_neg_integer, Time.t(), [
          time_slot
        ]) ::
          [time_slot]
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

  @spec handle_response(:store_closed | Availability.t()) :: [Availability.t()]
  defp handle_response(:store_closed), do: []
  defp handle_response(data), do: [data]
end
