if File.exist? '/opt/zookeeper'

  return_value = { 'installed' => true, 'version' => File.readlink('/opt/zookeeper').split('-')[-1] }

  return_value['rsa_2048_keys'] = {}
  users = [ 'zookeeper' ]
  users.each do |user|
    if File.exist? "/home/#{user}/.ssh/id_rsa.pub"
      return_value['rsa_2048_keys'][user] = File.open("/home/#{user}/.ssh/id_rsa.pub", 'r') { |f| f.read }
    end
  end

  if File.exist? '/home/zookeeper/.ssh/id_rsa.pub'
    return_value['rsa_2048_key'] = File.open('/home/zookeeper/.ssh/id_rsa.pub', 'r') { |f| f.read }
  end

  if File.exist? '/etc/zookeeper/conf/.cluster'
    return_value['cluster'] = File.open('/etc/zookeeper/conf/.cluster', 'r') { |f| f.read }
  end

  return_value['roles'] = {}
  roles = ['participant','observer']
  roles.each do |role|
    if File.exist? "/etc/hadoop/conf/.#{role}"
      return_value['roles'][role] = true
    else
      return_value['roles'][role] = false
    end
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
