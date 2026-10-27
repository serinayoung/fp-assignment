# Concurrent Log Processing System

A functional programming group assignment demonstrating concurrency and distributed behavior using Elixir, deployed inside an Ubuntu 22.04 Linux Virtual Machine.

## 🚀 Project Overview
This application simulates a distributed system where a central **Dispatcher** spawns multiple lightweight **Workers** to process log files concurrently. Instead of using threads and shared memory (which can cause race conditions), the system uses Elixir's **Actor Model**. Each worker processes a file independently and sends the results back to the dispatcher via **message passing**.

## 🧠 Functional Programming Concepts Applied
1. **Pure Functions**: The parsing and counting logic (`LogParser.count_levels/1` and `LogParser.merge/2`) are pure; they produce no side effects and rely only on their inputs.
2. **Immutable Data**: Data structures are never modified in-place. The `Enum.reduce` function builds a new map to aggregate results.
3. **Higher-Order Functions**: Functions like `Enum.map`, `Enum.reduce`, and `Enum.each` are used to abstract control flow.
4. **Message Passing (Actor Model)**: Processes communicate via `send/2` and `receive`, eliminating the need for locks or shared mutable state.

## 📂 File Structure
* `main.exs`: The main dispatcher module (spawns workers, collects results, merges).
* `log_parser.ex`: Contains pure functions to parse log lines and count INFO/ERROR levels.
* `log_parser_test.exs`: Unit tests for the pure functions.
* `log1.txt` - `log5.txt`: Sample log files for demonstration.

## 🛠️ How to Run (Linux Environment)
Ensure Elixir is installed on your Linux machine (`sudo apt install elixir`).

Run the main application with default log files:
```bash
elixir main.exs
