require 'job_sequencer'

describe JobSequencer do

	subject(:job_sequencer) do	
		described_class.new
	end

	it 'should respond to #process with 1 argument' do
		is_expected.to respond_to(:process).with(1).argument
	end

	describe '#process' do

		context 'given no jobs' do
			let(:joblist) { '' }
			it 'should return no jobs' do
				expect(subject.process(joblist)).to eq([])
			end
		end

		context 'given one job' do
			let(:joblist) do
					%Q{
						a =>
					}
				end
			it 'given one job should return one job' do
				
				expect(subject.process(joblist)).to eq(['a'])
			end
		end

		context 'given three jobs' do
			let(:joblist) do
					%Q{
						a =>
						b =>
						c =>
					}
				end
			it 'should return all three jobs' do
				expect(subject.process(joblist)).to eq(['a','b','c'])
			end
		end

		context 'given three jobs, one with a dependency' do
			let(:joblist) do
					%Q{
						a =>
						b => c
						c =>
					}
				end
			it 'should return all three jobs with c before b' do
				expect(subject.process(joblist)).to eq(['c', 'a', 'b'])
			end
		end

		context 'given multiple jobs with a dependenies' do
			let(:joblist) do
					%Q{
						a =>
						b => c
						c => f
						d => a
						e => b
						f =>
					}
				end
			it 'should return all jobs with f before c, c before b, b before e and a before d' do
				expect(subject.process(joblist)).to eq(['b', 'a', 'f', 'c', 'd', 'e'])
			end
		end

		context 'given a job that depends on itself' do
			let(:joblist) do
					%Q{
						a =>
						b =>
						c => c
					}
				end
			it 'should raise an error' do
				expect { subject.process(joblist) }.to raise_error(SequencerException, "Jobs cannot depend on themselves")
			end
		end

		context 'given multiple jobs that cycle' do
			let(:joblist) do
					%Q{
						a =>
						b => c
						c => f
						d => a
						e =>
						f => b
					}
				end
			it 'should raise an error' do
				expect { subject.process(joblist) }.to raise_error(SequencerException, "Jobs cannot have circular dependencies")
			end
		end

	end

end