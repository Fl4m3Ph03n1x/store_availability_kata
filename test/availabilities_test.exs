defmodule AvailabilitiesTest do
  use ExUnit.Case

  alias Availabilities
  alias Availabilities.{TimeSlotSettings, Schedule, Availability}

  describe "build" do
    test "returns availabilities for given day if there are slots for it" do
      #arrange
      settings = %TimeSlotSettings{
        slot_recurrrence: 3_600,
        slot_duration: 3_600
      }

      schedules = [
        %Schedule{
          weekday: :monday,
          start_time: ~T[09:00:00],
          end_time: ~T[18:00:00]
        }
      ]

      params = %Availabilities.Params{
        settings: settings,
        schedules: schedules
      }

      # #act
      actual = Availabilities.build(params, ~D[2021-05-03])
      expected = [
        %Availability{
          date: ~D[2021-05-03],
          weekday: :monday,
          slots: [
            %{
              start_time: ~T[09:00:00],
              end_time: ~T[10:00:00]
            },
            %{
              start_time: ~T[11:00:00],
              end_time: ~T[12:00:00]
            },
            %{
              start_time: ~T[13:00:00],
              end_time: ~T[14:00:00]
            },
            %{
              start_time: ~T[15:00:00],
              end_time: ~T[16:00:00]
            },
            %{
              start_time: ~T[17:00:00],
              end_time: ~T[18:00:00]
            }
          ]
        }
      ]

      # #assert
      assert actual == expected
    end

    test "returns empty availabilities for given day if the store is closed" do
      throw "Not implemented"
    end

    test "returns error if params have incorrect format" do
      throw "Not implemented"
    end
  end

end
