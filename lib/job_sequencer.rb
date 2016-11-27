class SequencerException < StandardError
	def initialize(msg = "Sequencer Exception")
		super
	end
end


class JobSequencer

	def initialize
		@jobs_arr = []
	end

	def process job_list_string
		@jobs_arr = parse_job_string(job_list_string)
		raise SequencerException, "Jobs cannot depend on themselves" if have_self_dependency?
		raise SequencerException, "Jobs cannot have circular dependencies" if have_circular_dependencies?

		out_arr = jobs_arr.map { |j| j[0] }
		# shift dependencies to the front of the queue
		jobs_arr.each do |j|
			if j.length == 2
				out_arr.delete(j[0])
				out_arr.delete(j[-1])
				out_arr << j[-1]
				out_arr << j[0]
			end
		end
		out_arr
	end


	private

		attr_reader :jobs_arr

		# split job input into job with it's dependency
		def parse_job_string job_list_string
			# split input lines
			arr = job_list_string.split(/\r?\n/)
			# strip all whitespace from lines
			arr.map! {|l| l.gsub(/\s+/, '') }
			# strip pointers from lines
			arr.map! {|l| l.gsub(/=>/, '') }
			# get rid of empty lines
			arr.reject!(&:empty?)
			arr
		end

		def jobs_with_dep_arr
			# only jobs with dependency have 2 chars
			jobs_arr.select { |j| j.length == 2 }
		end

		def have_self_dependency?
			jobs_with_dep_arr.any? { |j| j[0] == j[-1] }
		end

		def have_circular_dependencies?
			# sort jobs so we can check for cycles
			circ_jobs = jobs_with_dep_arr.sort { |a,b| b[0] <=> a[0] }
			# puts circ_jobs.inspect
			jobs_seen = []
			while circ_jobs.length > 0
				job = circ_jobs[0]
				# get dependent job
				dep_jobs = jobs_with_dep_arr.select { |j| job[0] != j[0] && j[0] == job[-1] }
				unless dep_jobs.empty?
					# we have a cycle if the dep job has already been walked
					return true if dep_jobs.any? { |d| jobs_seen.include? d }
					jobs_seen << job
				end
				circ_jobs.delete(job)
			end
			false
		end
	
end