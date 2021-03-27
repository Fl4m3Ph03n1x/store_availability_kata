defmodule Availabilities.Schedule do
  @moduledoc """
  Schedules the days when a store is open and for how long.
  """

  use TypedStruct

  alias Timex

  typedstruct do
    @typedoc "A schedule"

    field(:weekday, Timex.weekday_name(), enforce: true)
    field(:start_time, Time.t(), enforce: true)
    field(:end_time, Time.t(), enforce: true)
  end
end
