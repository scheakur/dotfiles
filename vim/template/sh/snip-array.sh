array=(
    hoge
    fuga
    piyo
)

echo ${array[0]}
echo ${array[1]}

length=${#array[@]}
echo $length

length=${#array[*]}
echo $length

for elem in ${array[@]}
do
    echo $elem
done

for elem in ${array[*]}
do
    echo $elem
done
