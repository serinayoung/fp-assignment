PROJECT: Concurrent Log Processor (Elixir)
COURSE: KT44502 Distributed Systems

REQUIREMENTS
- Linux (tested on Ubuntu 22.04 in WSL2)
- Elixir 1.12 or newer, with Erlang/OTP
- Internet (for installing)

INSTALL
1. sudo apt update
2. sudo apt install -y elixir unzip
3. elixir -v

RUN
1. Unzip the project and open a terminal in the folder.
2. chmod +x run.sh
3. ./run.sh

RUN UNIT TESTS
elixir log_parser_test.exs

RUN SEQUENTIAL VS CONCURRENT COMPARISON
elixir compare.exs

EXPECTED OUTPUT
Unit tests: 7 tests, 0 failures

./run.sh prints the Linux and Elixir versions, then:
Done: logs/server_1.log (errors: 24731, infos: 100184)
Done: logs/server_3.log (errors: 24742, infos: 99910)
Done: logs/server_2.log (errors: 25215, infos: 99826)
Done: logs/server_4.log (errors: 25262, infos: 99466)
Done: logs/server_5.log (errors: 24953, infos: 99930)
Final Result: %{total_errors: 124903, total_infos: 499316}

elixir compare.exs prints the time for sequential and concurrent
runs, then "Same result? true". Times differ on each machine.

NOTE: The order of the "Done" lines can change on every run.
This is normal. Each log file is processed by its own worker
process at the same time (concurrency).

FILES
- run.sh : startup script
- main.exs : main program (spawns workers, merges results)
- log_parser.ex : pure functions for counting log levels
- log_parser_test.exs : unit tests
- compare.exs : timing demo, sequential vs concurrent
- logs/ : server_1.log to server_5.log (real test logs)
- log1.txt to log5.txt : small sample log files
