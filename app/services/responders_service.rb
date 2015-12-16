class RespondersService
  include Singleton

  def batch_update_metadata(company, metadatas)
    metadatas.each do |metadata|
      update_metadata(company, metadata['email'], metadata.except('email'))
    end
  end

  def update_metadata(company, email, metadata)
    if email.nil?
      fail ArgumentError, 'Email cannot be nil'
    end

    ActiveRecord::Base.transaction do
      responder = Responder.find_by(company: company, email: email)
      if responder
        responder.update(metadata: (responder.metadata || {}).merge(metadata))
      else
        Responder.create(
          company: company,
          email: email,
          metadata: metadata
        )
      end
    end
  end
end
