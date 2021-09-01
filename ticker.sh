echo TICKER:start: `date +%s`
while :
do 
        sleep 1;
        cat << END
TICKER:tick_start
`ps -C tnt -o rss h| sed 's/^/TICKER:mem:/'`
TICKER:time:`date +%s`
END
done