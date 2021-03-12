# webservco/internet-bandwidth-test

Test internet bandwidth using speedtest-cli and write the results in a CSV file.

---

## Usage

Make sure to install `speedtest-cli`.

```sh
# create and edit the configuration file
cp config.sh.dist config.sh && vim config.sh
# make executable
chmod +x internet-bandwidth-test.sh
# run manually
. internet-bandwidth-test.sh
```

### Cron example

```sh
# run every 10 minutes
*/10 * * * * {PATH}internet-bandwidth-test.sh
```

---

## Source credit

https://askubuntu.com/a/597937

---
