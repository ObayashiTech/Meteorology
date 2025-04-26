# Meteorology

## Running the Project

After cloning the repository, follow these steps:

1. Fetch the dependencies:

    ```bash
    mix deps.get
    ```

2. To start the interactive CLI and navigate through the menu:

    ```bash
    mix run --no-halt
    ```

3. To directly print the calculated average temperatures without entering the CLI:

    ```bash
    mix run -e "Meteorology.Interface.show_results()"
    ```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/meteorology>.

