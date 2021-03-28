# Store Availability Kata

[![Elixir CI](https://github.com/Fl4m3Ph03n1x/store_availability_kata/actions/workflows/elixir.yml/badge.svg?branch=main)](https://github.com/Fl4m3Ph03n1x/store_availability_kata/actions/workflows/elixir.yml)

<p align="center">
    
    [![Elixir CI](https://github.com/Fl4m3Ph03n1x/store_availability_kata/actions/workflows/elixir.yml/badge.svg)](https://github.com/Fl4m3Ph03n1x/store_availability_kata/actions/workflows/elixir.yml)
    
    <a href="https://coveralls.io/github/Fl4m3Ph03n1x/store_availability_kata?branch=main">
        <img src="https://coveralls.io/repos/github/Fl4m3Ph03n1x/store_availability_kata/badge.svg?branch=main" alt="Coverage Status"/>
    </a>
</p>

Store managers and end consumers of our e-commerce started asking our imaginary store for a way to have their orders scheduled at checkout, so that managers could better prepare their inventory for a given date and time and consumers could better know the time window they should wait for couriers to arrive at their location.

In order to meet this growing need from our user base we need to create a simple booking system and, as one of the core features of this system, we will need a module to calculate and return the available time slots for a given date, considering the store's schedule plus some additional params. This would ideally be a standalone module that would work pretty much like a lib imported into the main codebase and so far we only have a name for it (`Availabilities`) and some definitions for its API as we can see below:


**Input structs:**

```elixir
# Settings for building time slots:
settings = %Availabilities.TimeSlotSettings{
  slot_recurrence: 3600, # Time interval in seconds between successive availability slots e.g. 3600 => time slots: 09:00, 10:00, 11:00, ...
  slot_duration: 3600, # Duration of a booking in seconds. In our case it's the delivery time window for a scheduled order
}

# Store's weekly schedule:
schedules = [
  %Availabilities.Schedule{
    weekday: :monday, # Week day in the weekly schedule
    start_time: ~T[09:00:00], # Time when the store opens
    end_time: ~T[18:00:00] # Time when the store closes
  },
  ...
]

# Params for calculating and building time slot availabilities:
params = %Availabilities.Params{
  settings: settings,
  schedules: schedules
}

```

**Output struct:**

```elixir
# Resulting struct with availabilities for a date:
%Availabilities.Availability{
	date: ~D[2021-05-03],
	weekday: :monday, 
	slots: [
		%{
	      start_time: ~T[09:00:00], # Time slot start time
	      end_time: ~T[10:00:00] # Time slot end time
     },
		%{
	      start_time: ~T[10:00:00],
	      end_time: ~T[11:00:00]
     },
		 ...
	]
}
```

Knowing these data structures, now we need you to implement the `Availabilities.build/2` function, the one that will actually calculate and return time slot availabilities based on a date and params passed as its arguments (more in the example below).

# Sample Inputs

```elixir
settings = %Availabilities.TimeSlotSettings{
  slot_recurrence: 7200,
  slot_duration: 3600
}

schedules = [
  %Availabilities.Schedule{
    weekday: :monday,
    start_time: ~T[09:00:00],
    end_time: ~T[18:00:00]
  },
  %Availabilities.Schedule{
    weekday: :wednesday,
    start_time: ~T[13:00:00],
    end_time: ~T[18:00:00]
  },
  %Availabilities.Schedule{
    weekday: :friday,
    start_time: ~T[09:00:00],
    end_time: ~T[13:00:00]
  }
]

params = %Availabilities.Params{
  settings: settings,
  schedules: schedules
}
```

# Expected Outputs

### 1) Availabilities for a Monday in the future:

```elixir
iex> Availabities.build(params, ~D[2021-05-03])
[
  %Availabities.Availability{
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
```

### 2) Availabilities for a Wednesday in the future:

```elixir
iex> Availabities.build(params, ~D[2021-06-16])
[
  %Availabities.Availability{
    date: ~D[2021-06-16],
    weekday: :wednesday,
    slots: [
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
```

### 3) Availabilities for a Friday in the future:

```elixir
iex> Availabities.build(params, ~D[2021-07-30])
[
  %Availabities.Availability{
    date: ~D[2021-07-30],
    weekday: :friday,
    slots: [
      %{
				start_time: ~T[09:00:00],
				end_time: ~T[10:00:00]
      },
      %{
        start_time: ~T[11:00:00],
        end_time: ~T[12:00:00]
      }
    ]
  }
]
```

### 4) Availabilities for a date with no daily schedule:

```elixir
iex> Availabities.build(params, ~D[2021-07-29])
[]
```

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `availabilities` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:availabilities, "~> 0.1.0"}
  ]
end
```

