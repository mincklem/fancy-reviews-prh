require_relative 'base_helpers'
require_relative '../../tests/command_runner'

module AcceptanceTests
  module CommandHelpers
    include BaseHelpers

    def run_command(*args)
      Tests::CommandRunner.run(*args) do |runner|
        runner.directory = fs.project_directory
        yield runner if block_given?
      end
    end

    def run_command!(*args)
      run_command(*args) do |runner|
        runner.run_successfully = true
        yield runner if block_given?
      end
    end

    def run_command_within_bundle(*args)
      run_command(*args) do |runner|
        runner.command_prefix = 'bundle exec'
        runner.env['BUNDLE_GEMFILE'] = fs.find_in_project('Gemfile').to_s

        runner.around_command do |run_command|
          Bundler.with_clean_env(&run_command)
        end

        yield runner if block_given?
      end
    end

    def run_command_within_bundle!(*args)
      run_command_within_bundle(*args) do |runner|
        runner.run_successfully = true
        yield runner if block_given?
      end
    end

    def run_rake_tasks(*tasks)
      options = tasks.last.is_a?(Hash) ? tasks.pop : {}
      args = ['bundle', 'exec', 'rake', *tasks, '--trace'] + [options]
      run_command(*args)
    end

    def run_rake_tasks!(*tasks)
      options = tasks.last.is_a?(Hash) ? tasks.pop : {}
      args = ['bundle', 'exec', 'rake', *tasks, '--trace'] + [options]
      run_command!(*args)
    end
  end
end
