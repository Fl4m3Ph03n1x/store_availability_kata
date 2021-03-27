defmodule Availabilities.TimeSlotSettings do
  @moduledoc """
  Data structure representing recurrence and duration of a given time slot.
  Slot duration can be greater then slot recurrence, allowing slots to overlap.
  """

  use TypedStruct

  typedstruct do
    @typedoc "A time slot setting"

    field(:slot_recurrrence, non_neg_integer, enforce: true)
    field(:slot_duration, non_neg_integer, enforce: true)
  end
end
