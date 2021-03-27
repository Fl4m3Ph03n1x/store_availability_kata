defmodule Availabilities.Params do
  @moduledoc """
  Parameters passed to the Availabilities build funciton.
  Encompasses the settings for timeslots and schedules.
  """

  use TypedStruct

  alias Availabilities.{Schedule, TimeSlotSettings}

  typedstruct do
    @typedoc "The parameters"

    field(:settings, TimeSlotSettings.t(), enforce: true)
    field(:schedules, [Schedule.t()], enforce: true)
  end
end
