module ForkableClient
  def forked_run
    Chef::Log.info "Forking chef instance to converge..."
    pid = fork
    if(pid)
      Chef::Log.info "Fork successful. Waiting for new chef pid: #{pid}"
      Process.waitpid2(pid)
      Chef::Log.info "Forked converge complete"
      true
    else
      Chef::Log.info "Forked instance now converging"
      do_run
      Chef::Log.info "Forked instance completed. Exiting."
      exit!
    end
  end

  def self.included(base)
    base.class_eval do
      alias_method :do_run, :run
      alias_method :run, :forked_run
    end
  end
end


unless(Chef::Client.instance_methods.map(&:to_sym).include?(:forked_run))
  class ForkedClientInsertion < StandardError
  end
  Chef::Client.send(:include, ForkableClient)
  raise ForkedClientInsertion.new "Chef client is now forkable. This is a non-fatal error."
end
