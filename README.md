# Test booking
[![Specs](https://github.com/blocknotes/test-booking/actions/workflows/specs.yml/badge.svg)](https://github.com/blocknotes/test-booking/actions/workflows/specs.yml)
[![Linters](https://github.com/blocknotes/test-booking/actions/workflows/linters.yml/badge.svg)](https://github.com/blocknotes/test-booking/actions/workflows/linters.yml)

Tested with:
- Ruby 2.7.2
- SQLite

### Routes

```sh
               Prefix Verb URI Pattern                                      Controller#Action
       api_passengers POST /api/flight_executions/:ref/passengers(.:format) api/passengers#create {:format=>:json}
api_flight_executions GET  /api/flight_executions(.:format)                 api/flight_executions#index {:format=>:json}
```
