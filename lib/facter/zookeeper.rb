if File.exist? '/opt/zookeeper'

  return_value = { 'installed' => true, 'version' => File.readlink('/opt/zookeeper').split('-')[-1] }

  if File.exist? '/home/zookeeper/.ssh/id_rsa.pub'
    return_value['rsa_2048_key'] = File.open('/home/zookeeper/.ssh/id_rsa.pub', 'r') { |f| f.read }
  end

  if File.exist? '/etc/zookeeper/conf/.cluster'
    return_value['cluster'] = File.open('/etc/zookeeper/conf/.cluster', 'r') { |f| f.read }
  end

  if File.exist? '/etc/zookeeper/conf/.role'
    return_value['role'] = File.open('/etc/zookeeper/conf/.role', 'r') { |f| f.read }
  end
  
  Facter.add(:zookeeper) do
    setcode do
      return_value
    end
  end

else
  Facter.add(:zookeeper) do
    setcode do
      { 'installed' => false }
    end
  end
end
