# Lavender

[![PyPI](https://img.shields.io/pypi/v/lavender.svg)](https://pypi.python.org/pypi/lavender)

A slightly more compromising Python code formatter, based on the latest stable release of
[Black](https://github.com/python/black#readme)
([`20.8b10`](https://github.com/psf/black/releases/tag/20.8b1) at the time of writing).

## Differences from Black

- The default line length is 99 instead of 88 (configurable with `--line-length`).
- Single quoted strings are preferred (configurable with
 `--string-normalization none/single/double`).
- Empty lines between `class`es and `def`s are treated no differently from other code. The old
  behavior, which sometimes inserts double empty lines between them, remains available via
  `--special-case-def-empty-lines`.
- The Vim plugin configuration variable for line length is named `g:lavender_line_length` instead
  of `g:lavender_linelength`, for consistency with the other configuration variable names.

## Documentation

Read up on [Black](https://github.com/python/black#readme), but replace `black` with `lavender` in your
head.

## Development

[Poetry](https://github.com/python-poetry/poetry#readme) is recommended for managing Python
development tooling.

To initialize an isolated Python development environment for Lavender:

```
poetry install
```

### Code Formatting

Code formatting for Python is handled by Lavender itself.

To check that the code is correctly formatted:

```
poetry run lavender --check .
```

To auto-format the code:

```
poetry run lavender .
```

### Type Checking

Type checking for Python is handled by [mypy](https://github.com/python/mypy#readme).

To check that the code is correctly typed:

```
poetry run mypy .
```

## License

Lavender is Copyright (c) 2019-2021 Michael Smith &lt;michael@spinda.net&gt;

Black, the software on which it was based, is Copyright (c) 2018-2020 Łukasz Langa

This program is free software: you can redistribute it and/or modify it under the terms of the MIT
License.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without
even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the MIT
License for more details.

You should have received a [copy](LICENSE) of the MIT License along with this program. If not, see
[http://opensource.org/licenses/MIT](http://opensource.org/licenses/MIT).

### Contribution

Unless you explicitly state otherwise, any contribution intentionally submitted for inclusion in
this work by you shall be licensed as above, without any additional terms or conditions.

[modeline]: # ( vim: set tw=99 ts=2 sw=2 et: )
