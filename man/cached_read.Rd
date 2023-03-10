% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/cached_read.R
\name{cached_read}
\alias{cached_read}
\alias{use_caching}
\alias{cached_read_csv}
\title{Read data and save into a local "cache" file for easier management and re-reading.}
\usage{
cached_read(
  files,
  read_fn,
  cache_type = NULL,
  write_cache_fn = NULL,
  read_cache_fn = NULL,
  label = "data",
  cache_dir = NULL,
  check = "file_info"
)

use_caching(
  expr,
  cache_type = NULL,
  write_cache_fn = NULL,
  read_cache_fn = NULL,
  label = "data",
  cache_dir = NULL,
  check = "exists"
)

cached_read_csv(
  files,
  cache_type = NULL,
  write_cache_fn = NULL,
  read_cache_fn = NULL,
  label = "data",
  cache_dir = NULL,
  check = "file_info",
  ...
)
}
\arguments{
\item{files}{A vector of path(s) to file(s). This will be passed as the first argument to `read_fn`.}

\item{read_fn}{A function that can read `files` into a data frame.
This can be one of three options:

  1. Standard function object, e.g. `readr::read_csv`

  2. An anonymous function, e.g. `\(files) readr::read_csv(files) |> janitor::clean_names()`

 If non-standard parameters are desired, an anonymous function should be used, e.g.

     `\(files) readr::read_csv(files, col_names = FALSE)`

 To use multiple files with a function that only takes a single file, use `lapply` or `purrr::map` and then `rbind` or `purr::list_rbind`, e.g.

     `\(files) lapply(files, data.table::fread) |> rbind()`
     `\(files) purrr::map(files, data.table::fread) |> purrr::list_rbind()`}

\item{cache_type}{The type of file to use for caching.
This can be one of two options:

 1. One of the following strings:
     "arrow" (same as `write_cache_fn=arrow::write_feather` and `read_cache_fn=arrow::read_feather`),
     "csv" (same as `readr::write_csv` and `readr::read_csv` if `readr` is installed; otherwise base R `utils::write.csv` and `utils::read.csv`)
 2. (Default) NULL:
     Uses `write_cache_fn` and `read_cache_fn` if provided. Otherwise, uses `"arrow"`, if installed, or `"csv"`.}

\item{write_cache_fn, read_cache_fn}{Functions used to write and read the cache file. If this is provided, the `cache_type` must be NULL.}

\item{label}{The label to give the cached file,
e.g. generating a file with the path 'data.fused_arrow'.}

\item{cache_dir}{Path to the folder that will contain the cache file.
If NULL (default), uses the common path among the inputs, as determined by `fs::path_common`.}

\item{check}{Determines when to re-read from the original sources. This can be one of the following options:

  1. (default) "file_info": Stores file metadata and re-reads if there have been any changes.

  2. "exists": Checks whether the cache file exists in the `cache_dir` with the indicated label.

  3. "force": Does not do any checking and simply re-builds the cache file.}

\item{expr}{Expression that generates a tibble, typically reading from files.}

\item{...}{Arguments passed on to `readr::read_csv`.}
}
\value{
A `tibble`. (Results are coerced to a tibble so that they are not dependent on the various read functions.)
}
\description{
If no cache file already exists, performs the desired read operation and writes the results to a cache file. Optionally, also saves a cache file containing the latest file update info.
If the cache file exists, it is read instead. By default it also tracks for file updating so that the file(s) are
 re-read from scratch if they have changed.
}
\examples{
\dontrun{


# Standard read method
res <- some_files |>
  readr::read_csv() |>
  janitor::clean_names()

# With caching there's now a single file that can be re-read more quickly in the future.
res <- some_files |>
  cached_read(
    \(file) readr::read_csv(file)
      |> janitor::clean_names()
  )

res <- some_files |>
  readr::read_csv() |>
  janitor::clean_names() |>
  use_caching()
}
}
