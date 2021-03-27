defmodule Availabilities.Availability do
  @moduledoc """
  Contains the availabilities of a store for the given day.
  Will be empty if the store is closed.
  """

  use TypedStruct

  alias Timex

  typedstruct do
    @typedoc "The availability"

    field :date, Date.t, enforce: true
    field :weekday, Timex.weekday_name, enforce: true
    field :slots, [%{start_time: Time.t, end_time: Time.t}], enforce: true
  end
end
