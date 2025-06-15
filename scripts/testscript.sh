TESTING=(
    first
    second
    third
    fourth
    fifth
)

for pkg in "${TESTING[@]}"; do
    if [ "$pkg" = first ]
    then echo "$pkg"
    fi
done


