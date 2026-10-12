# webservco/internet-bandwidth-test

A Bash script.

Measures the internet connection's ping, download and upload speed with `speedtest-cli` and appends the result to a daily CSV file.

- Requires: Bash, [speedtest-cli](https://github.com/sivel/speedtest-cli)
- Related: `webservco/internet-latency-test` (the same for ping latency and packet loss)

---

## Installation

```shell
git clone https://github.com/webservco/internet-bandwidth-test.git
cd internet-bandwidth-test
cp config.sh.dist config.sh
```

---

## Usage

```shell
# Run once.
. internet-bandwidth-test.sh
```

Each run appends one line to `{log_path}{YYYY-MM}/{log_name}-{YYYY-MM-DD}.csv`, creating the directory and the file if needed.

```text
Date,Ping,Download,Upload,Message
2023-05-30T10:00:01,18.4,93.12,38.71,http://www.speedtest.net/result/0000000000.png,""
```

Ping is in ms, download and upload in Mbit/s.

### Cron

```shell
# Every 10 minutes.
*/10 * * * * /path/to/internet-bandwidth-test/internet-bandwidth-test.sh
```

---

## Configuration

Keys read from `config.sh`:

```shell
# Full path to the log directory, with trailing slash.
log_path='/full/path/'
log_name='internet-bandwidth-test'
# Leave empty for automatic selection. List servers with `speedtest-cli --list`.
server_id=''
# 1: also write the full speedtest-cli output in the Message column.
debug=1
```

---

## Notes

Each line has six values, but the header only lists five. The extra one is the share image URL, just before the message.

The full output is always written when the test fails (no ping, or a download speed of 0), even with `debug=0`.

Based on [this Ask Ubuntu answer](https://askubuntu.com/a/597937).

---

## License

[MIT](LICENSE)
