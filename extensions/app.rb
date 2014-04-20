module App

  module_function

  def caches_path
    NSSearchPathForDirectoriesInDomains(
      NSCachesDirectory, NSUserDomainMask, true)[0]
  end

  def nav
    App.window.rootViewController
  end

  def plist_key(key)
    NSBundle.mainBundle.objectForInfoDictionaryKey(key)
  end

  # db helpers

  def db
    App::Persistence
  end

  def db_delete(key)
    App.db[key.to_sym] = nil
    App.db[key.to_sym].nil?
  end

  def db_delete_at(index, key, attribute)
    record = App.db[key.to_sym].mutableCopy
    record[attribute.to_sym] ||= []

    array = record[attribute.to_sym].mutableCopy
    array.delete_at(index) if array.is_a?(Array)
    record[attribute.to_sym] = array

    App.db[key.to_sym] = record
    App.db[key.to_sym]
  end

  def db_push(val, key, attribute)
    record = App.db[key.to_sym].mutableCopy
    record[attribute.to_sym] ||= []

    array = record[attribute.to_sym].mutableCopy
    array.push(val)
    record[attribute.to_sym] = array

    App.db[key.to_sym] = record
    App.db[key.to_sym]
  end

  def db_update(key, attributes = {})
    record = App.db[key.to_sym].mutableCopy
    attributes.each { |k,v| record[k] = v }
    App.db[key.to_sym] = record
    App.db[key.to_sym]
  end

  # background helpers

  def async_http(&block)
    RMExtensions::Queue.async_http(&block)
  end

  def main_queue
    Dispatch::Queue.main
  end

  def queue
    Dispatch::Queue.concurrent('org.companyname.background')
  end

  # reachability helpers

  def online?
    r = Reachability.reachabilityForInternetConnection
    !(r.currentReachabilityStatus == NotReachable)
  end

  def wifi?
    r = Reachability.reachabilityForLocalWiFi
    r.currentReachabilityStatus == ReachableViaWiFi
  end

  def wwan?
    r = Reachability.reachabilityForLocalWiFi
    r.currentReachabilityStatus == ReachableViaWWAN
  end

end