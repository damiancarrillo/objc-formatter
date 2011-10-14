#! /usr/bin/env sh

if [ "${1}" == "" ]
then
    echo "Usage:" ${0} "test.dir"
    exit 1
fi

testDir="${1}"

for testCase in $(ls ${testDir})
do
    sut="${testDir}/${testCase}/sut"
    config="${testDir}/${testCase}/config"
    input="${testDir}/${testCase}/input"
    expected="${testDir}/${testCase}/expected"

    testCmd="${sut} -v configFile=${config} ${input} | diff -B ${expected} -"
    result=$(eval "${testCmd}")

    if [[ ${result} == "" ]]
    then
        echo "  ✓ ${testCase}"
    else
        differences=$(echo ${result} | wc -l)

        failureDir="test/failures/$(basename ${testDir})"
        mkdir -p "${failureDir}"

        echo "  ✗ ${testCase} (see ${failureDir}/${testCase}.report)"
        echo "${result}" > "${failureDir}/${testCase}.report"
    fi
done
