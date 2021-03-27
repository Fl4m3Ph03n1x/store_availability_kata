defmodule AvailabilitiesTest do
  use ExUnit.Case

  alias Availabilities
  alias Availabilities.{Availability, Schedule, TimeSlotSettings}

  describe "build" do
    test "returns availabilities for given day if there are slots for it" do
      # arrange
      settings = %TimeSlotSettings{
        slot_recurrrence: 3_600,
        slot_duration: 3_600
      }

      schedules = [
        %Schedule{
          weekday: :monday,
          start_time: ~T[09:00:00],
          end_time: ~T[14:00:00]
        },
        %Schedule{
          weekday: :wednesday,
          start_time: ~T[13:00:00],
          end_time: ~T[18:00:00]
        },
        %Schedule{
          weekday: :friday,
          start_time: ~T[09:00:00],
          end_time: ~T[13:00:00]
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
              start_time: ~T[10:00:00],
              end_time: ~T[11:00:00]
            },
            %{
              start_time: ~T[11:00:00],
              end_time: ~T[12:00:00]
            },
            %{
              start_time: ~T[12:00:00],
              end_time: ~T[13:00:00]
            },
            %{
              start_time: ~T[13:00:00],
              end_time: ~T[14:00:00]
            }
          ]
        }
      ]

      # assert
      assert actual == expected
    end

    test "returns empty availabilities for given day if the store is closed" do
      # arrange
      settings = %TimeSlotSettings{
        slot_recurrrence: 3_600,
        slot_duration: 3_600
      }

      schedules = [
        %Schedule{
          weekday: :monday,
          start_time: ~T[09:00:00],
          end_time: ~T[14:00:00]
        }
      ]

      params = %Availabilities.Params{
        settings: settings,
        schedules: schedules
      }

      # #act
      actual = Availabilities.build(params, ~D[2021-05-04])
      expected = []

      # assert
      assert actual == expected
    end
  end
end
