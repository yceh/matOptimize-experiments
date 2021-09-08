echo TICKER:start: `date +%s`
while :
do 
        sleep 120;
        cat << END
TICKER:tick_start
`ps -C tnt -o rss h| sed 's/^/TICKER:mem:/'`
TICKER:time:`date +%s`
END
done
