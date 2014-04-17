class ResourceAuthorizer < Authority::Authorizer

  def self.default(adjective, user)
    if adjective == :deletable
      user.admin?
    else
      true
    end
  end

end

