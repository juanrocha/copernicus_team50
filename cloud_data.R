## copernicus hackathon

library(tidyverse)
library(lubridate)
library(tictoc)

## Cloud data:
dat <- read_csv2(
  "data/metobs_totalCloudCover_all_sites.csv",
  col_types = cols(
    Id = col_double(), Name = col_character(), Latitude = col_character(),
  Longitude = col_character(), Height = col_double(), Active = col_character()))

dat <- dat %>%
  mutate(
    Longitude = str_replace_all(Longitude, pattern = ",", replacement = "."),
    Longitude = str_remove_all(Longitude, " th most common"),
    Latitude = str_replace_all(Latitude, pattern = ",", replacement = ".")
  ) %>%
  mutate(Longitude = as.numeric(Longitude), Latitude = as.numeric(Latitude))


dat <- dat %>%
  filter(Active == "Yes" | Active == "Ja") %>%
  select(id = Id, name = Name, lon = Longitude, lat = Latitude)


# copied from the Jupyter notebook: dates when pictures were taken
times <- tibble(
  dates = c('2018-04-01T10:50:28.741500000', '2018-04-03T10:40:42.193500000',
       '2018-04-05T10:30:21.744500000', '2018-04-08T10:40:21.742000000',
       '2018-04-11T10:50:29.243500000', '2018-04-15T10:30:22.241000000',
       '2018-04-16T10:50:27.242500000', '2018-04-18T10:40:22.243500000',
       '2018-04-23T10:40:20.242000000', '2018-05-03T10:40:20.244500000',
       '2018-05-10T10:30:19.743000000', '2018-05-13T10:40:19.743500000',
       '2018-05-25T10:30:22.743000000', '2018-05-26T10:50:26.241500000',
       '2018-05-28T10:40:22.242000000', '2018-05-31T10:50:29.743500000',
       '2018-06-17T10:40:21.240500000', '2018-06-24T10:30:21.740000000',
       '2018-07-02T10:40:20.244000000', '2018-07-10T10:50:29.742000000',
       '2018-07-12T10:40:19.742500000', '2018-07-17T10:40:22.240500000',
       '2018-07-20T10:50:29.742000000', '2018-07-22T10:40:19.741000000',
       '2018-07-27T10:40:22.241000000', '2018-07-29T10:30:19.243000000',
       '2018-08-01T10:40:18.740500000', '2018-08-08T10:30:18.242500000',
       '2018-08-09T10:50:28.743500000', '2018-08-23T10:30:21.241500000',
       '2018-08-31T10:40:16.241000000', '2018-09-05T10:40:20.742500000',
       '2018-09-07T10:30:16.243500000', '2018-09-08T10:50:22.742500000',
       '2018-09-10T10:40:16.244000000', '2018-09-17T10:30:16.242000000',
       '2018-09-20T10:40:16.743500000', '2018-09-22T10:30:19.243000000',
       '2018-10-27T10:31:26.240500000', '2019-02-17T10:41:32.958000000',
       '2019-02-17T10:41:34.871000000', '2019-02-20T10:51:21.251000000',
       '2019-02-20T10:51:23.264000000', '2019-02-24T10:31:03.741384000',
       '2019-02-24T10:31:05.552187000', '2019-03-02T10:51:05.624662000',
       '2019-03-02T10:51:07.635696000', '2019-03-04T10:41:01.439879000',
       '2019-03-04T10:41:03.354152000', '2019-03-07T10:50:59.631356000',
       '2019-03-07T10:51:01.641125000', '2019-03-11T10:31:02.892634000',
       '2019-03-11T10:31:04.706427000', '2019-03-12T10:51:30.182833000',
       '2019-03-12T10:51:32.188245000', '2019-03-16T10:31:03.302140000',
       '2019-03-16T10:31:05.116993000', '2019-03-17T10:51:01.005970000',
       '2019-03-17T10:51:03.034820000', '2019-03-19T10:41:02.629345000',
       '2019-03-19T10:41:04.540356000', '2019-03-22T10:51:06.492790000',
       '2019-03-22T10:51:08.515374000', '2019-03-26T10:31:09.747809000',
       '2019-03-26T10:31:11.560779000', '2019-03-27T10:51:07.203819000',
       '2019-03-27T10:51:09.224790000', '2019-03-31T10:31:05.336576000',
       '2019-03-31T10:31:07.149872000', '2019-04-01T10:51:07.777666000',
       '2019-04-01T10:51:09.798602000', '2019-04-05T10:31:10.951141000',
       '2019-04-05T10:31:12.763823000', '2019-04-06T10:51:08.092168000',
       '2019-04-06T10:51:10.110373000', '2019-04-08T10:41:10.118494000',
       '2019-04-08T10:41:12.031248000', '2019-04-10T10:31:06.134689000',
       '2019-04-10T10:31:07.945660000', '2019-04-18T10:41:11.083039000',
       '2019-04-18T10:41:12.996512000', '2019-04-23T10:41:10.738903000',
       '2019-04-23T10:41:12.652590000', '2019-04-25T10:31:12.745562000',
       '2019-04-25T10:31:14.556458000', '2019-04-26T10:51:09.270389000',
       '2019-04-26T10:51:11.283927000', '2019-04-28T10:41:11.788048000',
       '2019-04-28T10:41:13.702641000', '2019-05-05T10:31:15.098983000',
       '2019-05-06T10:51:09.483678000', '2019-05-06T10:51:11.496426000',
       '2019-05-18T10:41:12.443058000', '2019-05-23T10:41:10.791379000',
       '2019-05-23T10:41:12.705517000', '2019-06-02T10:41:10.296531000',
       '2019-06-02T10:41:12.209904000', '2019-06-05T10:51:08.531627000',
       '2019-06-05T10:51:10.547714000', '2019-06-12T10:41:10.579494000',
       '2019-06-12T10:41:12.492701000', '2019-06-14T10:31:12.910525000',
       '2019-06-14T10:31:14.721553000', '2019-06-15T10:51:09.087545000',
       '2019-06-15T10:51:10.506251000', '2019-06-20T10:51:15.508749000',
       '2019-06-20T10:51:17.517319000', '2019-06-24T10:31:13.374787000',
       '2019-06-24T10:31:15.184619000', '2019-06-30T10:51:15.840403000',
       '2019-06-30T10:51:17.848096000', '2019-07-05T10:51:10.034237000',
       '2019-07-05T10:51:12.042454000', '2019-07-09T10:31:12.809547000',
       '2019-07-09T10:31:14.618106000', '2019-07-12T10:41:11.691306000',
       '2019-07-12T10:41:13.606176000', '2019-07-19T10:31:12.837108000',
       '2019-07-19T10:31:14.646450000', '2019-07-27T10:41:12.270575000',
       '2019-07-27T10:41:14.185383000', '2019-07-29T10:31:12.645473000',
       '2019-07-29T10:31:14.453787000', '2019-07-30T10:51:15.593103000',
       '2019-07-30T10:51:17.599622000', '2019-08-03T10:31:13.146141000',
       '2019-08-03T10:31:14.954674000', '2019-08-04T10:51:09.732865000',
       '2019-08-04T10:51:11.737847000', '2019-08-06T10:41:11.846276000',
       '2019-08-06T10:41:13.762058000', '2019-08-24T10:51:08.494133000',
       '2019-08-24T10:51:10.499206000', '2019-09-02T10:31:10.817563000',
       '2019-09-02T10:31:12.626357000', '2019-09-07T10:31:04.854386000',
       '2019-09-07T10:31:06.662144000', '2019-09-27T10:31:05.850331000',
       '2019-09-27T10:31:07.662295000', '2019-10-03T10:51:08.533034000',
       '2019-10-03T10:51:10.548219000', '2019-10-08T10:51:09.044526000',
       '2019-10-17T10:31:11.830097000', '2019-10-17T10:31:13.641080000',
       '2019-10-23T10:51:29.181124000', '2019-10-23T10:51:31.191205000',
       '2019-10-28T10:51:16.983632000', '2019-10-28T10:51:18.996419000'))

times <- times %>%
  mutate(dates = ymd_hms(dates)) %>%
  mutate(
    day = date(dates),
    h = hour(dates),
    m = minute(dates),
    s = second(dates)) %>%
  mutate(time = readr::parse_time(paste(h,m,sep=":"))) %>%
  select(-h, -m, -s) %>%
  mutate(dates_round = round_date(dates, "hour"))


## Files downloaded frm SMHI (https://www.smhi.se/data/meteorologi/ladda-ner-meteorologiska-observationer#param=totalCloudCover,stations=all,stationid=124300)
##
path <- "data/smhi_cloud_data"
files <- list.files(path = path)
ids <- files %>% str_split("_") %>% map(function(x) x[3]) %>% unlist()


out <- list()


read_files <- function(x,y){
  # x is the file
  # y is the ids
  obs <- read_delim(
    file = paste(path, x, sep = "/"),
    delim = ";",
    skip = 9,
    col_types = cols(
      Datum = col_date(format = ""),
      `Tid (UTC)` = col_time(format = ""),
      `Total molnmängd` = col_double(),
      Kvalitet = col_character(),
      X5 = col_logical(),
      `Tidsutsnitt:` = col_character()
    )
  )
  ## Some files have more than 10 rows to skip, here I do two extra checks as max
  ## to correct.
  if(names(obs)[1] != "Datum") {
    obs <- read_delim(
      file = paste(path, x, sep = "/"),
      delim = ";",
      skip = 10,
      col_types = cols(
        Datum = col_date(format = ""),
        `Tid (UTC)` = col_time(format = ""),
        `Total molnmängd` = col_double(),
        Kvalitet = col_character(),
        X5 = col_logical(),
        `Tidsutsnitt:` = col_character()
      )
    )
  }
  if(names(obs)[1] != "Datum") {
    obs <- read_delim(
      file = paste(path, x, sep = "/"),
      delim = ";",
      skip = 11,
      col_types = cols(
        Datum = col_date(format = ""),
        `Tid (UTC)` = col_time(format = ""),
        `Total molnmängd` = col_double(),
        Kvalitet = col_character(),
        X5 = col_logical(),
        `Tidsutsnitt:` = col_character()
      )
    )
  }

  obs <- obs %>%
    select(1:4) %>%
    rename(date = 1, hour_UTC = 2, total_clouds = 3, quality = 4)

  obs <- obs  %>%
    filter (date > min(times$day)) %>%
    mutate(dates_round = make_datetime(
      year = year(date), month = month(date), day = day(date), hour = hour(hour_UTC), min = minute(hour_UTC)
    ))

  annotated <- times %>%
    left_join(obs) %>%
    select(-day, -time, -date, -hour_UTC) %>%
    filter(!is.na(total_clouds))

  annotated$id <- y

  return(annotated)
}

read_safe <- safely(read_files)

tic()
out <- map2(files, ids, read_safe)
toc() # 135 files, 30 secs

## Detect files with errors: errors are common when the number of rows to skip is > 9
error <- map(out, function(x) !is.null(x$error)) %>% unlist()

out <- out[!error]

## Detect files witout obs: when the station stop working before satellite images were taken.
is_ok <- map(out, function(x) dim(x$result)[1] > 0) %>% unlist()

out <- transpose(out)

out <- out$result[is_ok] %>%
  bind_rows() %>%
  mutate(id = as.numeric(id)) %>%
  left_join(dat)

write_csv(out, "annotated_clouds.csv")

skimr::skim(out)
out %>% pull(quality) %>% unique()
