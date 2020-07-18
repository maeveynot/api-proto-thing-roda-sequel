def ENV_delete_in_prod(k)
  ENV['RACK_ENV'] == 'production' ? ENV.delete(k) : ENV[k]
end
