### README

* Run './job_sequencer'
* Enter jobs with or without dependencies, one job per line
* Press enter twice to process

### NOTES

Working commit history can be viewed on this repo.
I began with a basic scaffold of specs for the exercies and worked through.
The validation of input was my initial focus as I knew this would drive my approach.
I had a few difference solutions to the cyclic dependency check for example a recursive function, I found those to be unreliable and only worked if jobs were entered in a fixed order due to lack of unique job idendifers.
I settled on a reducing array of jobs to check with a second array to track the jobs already seen in the cycle.

It also became apparent that the solution to sorting the sequence was not robust when jobs were passed in a different order, the returned sequence did not correctly order the dependency chain.

-- 

For a production application I would likely improve this to create a `Sequencer` and `Job` as seperate classes, working with strings alone made it difficult to arrive at a solution for cyclic dependency checking without something like IDs for jobs.