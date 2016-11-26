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
			false
		end
	
end