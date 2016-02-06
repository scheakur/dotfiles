n=1
while [ $n -le 10 ]; do
    echo "$n times"
    n=$((n+1))
done

while [ 1 ]; do
    echo 'loop'
    break
done
