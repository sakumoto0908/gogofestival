shared_examples_for 'rails_3_reset_password_model' do
  # ----------------- PLUGIN CONFIGURATION -----------------------
  let(:user) { create_new_user }

  describe 'loaded plugin configuration' do
    before(:all) do
      sorcery_reload!([:reset_password], reset_password_mailer: ::SorceryMailer)
    end

    after(:each) do
      User.sorcery_config.reset!
    end

    context 'API' do
      specify { expect(user).to respond_to :deliver_reset_password_instructions! }

      specify { expect(user).to respond_to :change_password }

      specify { expect(user).to respond_to :change_password! }

      it 'responds to .load_from_reset_password_token' do
        expect(User).to respond_to :load_from_reset_password_token
      end
    end

    it "allows configuration option 'reset_password_token_attribute_name'" do
      sorcery_model_property_set(:reset_password_token_attribute_name, :my_code)

      expect(User.sorcery_config.reset_password_token_attribute_name).to eq :my_code
    end

    it "allows configuration option 'reset_password_mailer'" do
      sorcery_model_property_set(:reset_password_mailer, TestUser)

      expect(User.sorcery_config.reset_password_mailer).to eq TestUser
    end

    it "enables configuration option 'reset_password_mailer_disabled'" do
      sorcery_model_property_set(:reset_password_mailer_disabled, :my_reset_password_mailer_disabled)

      expect(User.sorcery_config.reset_password_mailer_disabled).to eq :my_reset_password_mailer_disabled
    end

    it 'if mailer is nil and mailer is enabled, throw exception!' do
      expect { sorcery_reload!([:reset_password], reset_password_mailer_disabled: false) }.to raise_error(ArgumentError)
    end

    it 'if mailer is disabled and mailer is nil, do NOT throw exception' do
      expect { sorcery_reload!([:reset_password], reset_password_mailer_disabled: true) }.to_not raise_error
    end

    it "allows configuration option 'reset_password_email_method_name'" do
      sorcery_model_property_set(:reset_password_email_method_name, :my_mailer_method)

      expect(User.sorcery_config.reset_password_email_method_name).to eq :my_mailer_method
    end

    it "allows configuration option 'reset_password_expiration_period'" do
      sorcery_model_property_set(:reset_password_expiration_period, 16)

      expect(User.sorcery_config.reset_password_expiration_period).to eq 16
    end

    it "allows configuration option 'reset_password_email_sent_at_attribute_name'" do
      sorcery_model_property_set(:reset_password_email_sent_at_attribute_name, :blabla)

      expect(User.sorcery_config.reset_password_email_sent_at_attribute_name).to eq :blabla
    end

    it "allows configuration option 'reset_password_time_between_emails'" do
      sorcery_model_property_set(:reset_password_time_between_emails, 16)

      expect(User.sorcery_config.reset_password_time_between_emails).to eq 16
    end
  end

  describe 'when activated with sorcery' do
    before(:all) do
      sorcery_reload!([:reset_password], reset_password_mailer: ::SorceryMailer)
    end

    before(:each) do
      User.sorcery_adapter.delete_all
      user
    end

    after(:each) do
      Timecop.return
    end

    it 'load_from_reset_password_token returns user when token is found' do
      user.generate_reset_password_token!
      updated_user = User.sorcery_adapter.find(user.id)

      expect(User.load_from_reset_password_token(user.reset_password_token)).to eq updated_user
    end

    it 'load_from_reset_password_token does NOT return user when token is NOT found' do
      user.generate_reset_password_token!

      expect(User.load_from_reset_password_token('a')).to be_nil
    end

    it 'load_from_reset_password_token returns user when token is found and not expired' do
      sorcery_model_property_set(:reset_password_expiration_period, 500)
      user.generate_reset_password_token!
      updated_user = User.sorcery_adapter.find(user.id)

      expect(User.load_from_reset_password_token(user.reset_password_token)).to eq updated_user
    end

    it 'load_from_reset_password_token does NOT return user when token is found and expired' do
      sorcery_model_property_set(:reset_password_expiration_period, 0.1)
      user.generate_reset_password_token!
      Timecop.travel(Time.now.in_time_zone + 0.5)

      expect(User.load_from_reset_password_token(user.reset_password_token)).to be_nil
    end

    it 'load_from_reset_password_token is always valid if expiration period is nil' do
      sorcery_model_property_set(:reset_password_expiration_period, nil)
      user.generate_reset_password_token!
      updated_user = User.sorcery_adapter.find(user.id)

      expect(User.load_from_reset_password_token(user.reset_password_token)).to eq updated_user
    end

    it 'load_from_reset_password_token returns nil if token is blank' do
      expect(User.load_from_reset_password_token(nil)).to be_nil
      expect(User.load_from_reset_password_token('')).to be_nil
    end

    describe '#load_from_reset_password_token' do
      context 'in block mode' do
        it 'yields user when token is found' do
          user.generate_reset_password_token!
          updated_user = User.sorcery_adapter.find(user.id)

          User.load_from_reset_password_token(user.reset_password_token) do |user2, failure|
            expect(user2).to eq updated_user
            expect(failure).to be_nil
          end
        end

        it 'does NOT yield user when token is NOT found' do
          user.generate_reset_password_token!

          User.load_from_reset_password_token('a') do |user2, failure|
            expect(user2).to be_nil
            expect(failure).to eq :user_not_found
          end
        end

        it 'yields user when token is found and not expired' do
          sorcery_model_property_set(:reset_password_expiration_period, 500)
          user.generate_reset_password_token!
          updated_user = User.sorcery_adapter.find(user.id)

          User.load_from_reset_password_token(user.reset_password_token) do |user2, failure|
            expect(user2).to eq updated_user
            expect(failure).to be_nil
          end
        end

        it 'yields user and failure reason when token is found and expired' do
          sorcery_model_property_set(:reset_password_expiration_period, 0.1)
          user.generate_reset_password_token!
          Timecop.travel(Time.now.in_time_zone + 0.5)

          User.load_from_reset_password_token(user.reset_password_token) do |user2, failure|
            expect(user2).to eq user
            expect(failure).to eq :token_expired
          end
        end

        it 'is always valid if expiration period is nil' do
          sorcery_model_property_set(:reset_password_expiration_period, nil)
          user.generate_reset_password_token!
          updated_user = User.sorcery_adapter.find(user.id)

          User.load_from_reset_password_token(user.reset_password_token) do |user2, failure|
            expect(user2).to eq updated_user
            expect(failure).to be_nil
          end
        end

        it 'returns nil if token is blank' do
          [nil, ''].each do |token|
            User.load_from_reset_password_token(token) do |user2, failure|
              expect(user2).to be_nil
              expect(failure).to eq :invalid_token
            end
          end
        end
      end
    end

    it "'deliver_reset_password_instructions!' generates a reset_password_token" do
      expect(user.reset_password_token).to be_nil

      user.deliver_reset_password_instructions!

      expect(user.reset_password_token).not_to be_nil
    end

    it "'deliver_reset_password_instructions! returns a Mail::Message object" do
      expect(user.deliver_reset_password_instructions!).to be_an_instance_of Mail::Message
    end

    it 'the reset_password_token is random' do
      sorcery_model_property_set(:reset_password_time_between_emails, 0)
      user.deliver_reset_password_instructions!
      old_password_code = user.reset_password_token
      user.deliver_reset_password_instructions!

      expect(user.reset_password_token).not_to eq old_password_code
    end

    describe '#increment_password_reset_page_access_counter' do
      it 'increments reset_password_page_access_count_attribute_name' do
        expected_count = user.access_count_to_reset_password_page + 1
        user.increment_password_reset_page_access_counter
        expect(user.access_count_to_reset_password_page).to eq expected_count
      end
    end

    describe '#reset_password_reset_page_access_counter' do
      it 'reset reset_password_page_access_count_attribute_name into 0' do
        user.update(access_count_to_reset_password_page: 10)
        user.reset_password_reset_page_access_counter
        expect(user.access_count_to_reset_password_page).to eq 0
      end
    end

    context 'mailer is enabled' do
      it 'sends an email on reset' do
        old_size = ActionMailer::Base.deliveries.size
        user.deliver_reset_password_instructions!

        expect(ActionMailer::Base.deliveries.size).to eq old_size + 1
      end

      it 'calls send_reset_password_email! on reset' do
        expect(user).to receive(:send_reset_password_email!).once

        user.deliver_reset_password_instructions!
      end

      it 'does not send an email if time between emails has not passed since last email' do
        sorcery_model_property_set(:reset_password_time_between_emails, 10_000)
        old_size = ActionMailer::Base.deliveries.size
        user.deliver_reset_password_instructions!

        expect(ActionMailer::Base.deliveries.size).to eq old_size + 1

        user.deliver_reset_password_instructions!

        expect(ActionMailer::Base.deliveries.size).to eq old_size + 1
      end

      it 'sends an email if time between emails has passed since last email' do
        sorcery_model_property_set(:reset_password_time_between_emails, 0.5)
        old_size = ActionMailer::Base.deliveries.size
        user.deliver_reset_password_instructions!

        expect(ActionMailer::Base.deliveries.size).to eq old_size + 1

        Timecop.travel(Time.now.in_time_zone + 0.5)
        user.deliver_reset_password_instructions!

        expect(ActionMailer::Base.deliveries.size).to eq old_size + 2
      end
    end

    context 'mailer is disabled' do
      before(:all) do
        sorcery_reload!([:reset_password], reset_password_mailer_disabled: true, reset_password_mailer: ::SorceryMailer)
      end

      it 'sends an email on reset' do
        old_size = ActionMailer::Base.deliveries.size
        user.deliver_reset_password_instructions!

        expect(ActionMailer::Base.deliveries.size).to eq old_size
      end

      it 'does not call send_reset_password_email! on reset' do
        expect(user).to receive(:send_reset_password_email!).never

        user.deliver_reset_password_instructions!
      end

      it 'does not send an email if time between emails has not passed since last email' do
        sorcery_model_property_set(:reset_password_time_between_emails, 10_000)
        old_size = ActionMailer::Base.deliveries.size
        user.deliver_reset_password_instructions!

        expect(ActionMailer::Base.deliveries.size).to eq old_size

        user.deliver_reset_password_instructions!

        expect(ActionMailer::Base.deliveries.size).to eq old_size
      end

      it 'sends an email if time between emails has passed since last email' do
        sorcery_model_property_set(:reset_password_time_between_emails, 0.5)
        old_size = ActionMailer::Base.deliveries.size
        user.deliver_reset_password_instructions!

        expect(ActionMailer::Base.deliveries.size).to eq old_size

        Timecop.travel(Time.now.in_time_zone + 0.5)
        user.deliver_reset_password_instructions!

        expect(ActionMailer::Base.deliveries.size).to eq old_size
      end
    end

    it 'when change_password! is called, deletes reset_password_token and calls #save!' do
      user.deliver_reset_password_instructions!

      expect(user.reset_password_token).not_to be_nil
      expect(user).to_not receive(:save)
      expect(user).to receive(:save!)

      user.change_password!('blabulsdf')

      expect(user.reset_password_token).to be_nil
    end

    it 'when change_password! is called with empty argument, raise an exception' do
      expect {
        user.change_password!('')
      }.to raise_error(ArgumentError, 'Blank password passed to change_password!')
    end

    it 'when change_password! is called with nil argument, raise an exception' do
      expect {
        user.change_password!(nil)
      }.to raise_error(ArgumentError, 'Blank password passed to change_password!')
    end

    it 'when change_password is called, deletes reset_password_token and calls #save' do
      new_password = 'blabulsdf'

      user.deliver_reset_password_instructions!
      expect(user.reset_password_token).not_to be_nil
      expect(user).to_not receive(:save!)
      expect(user).to receive(:save)

      user.change_password(new_password)

      expect(user.reset_password_token).to be_nil
    end

    it 'returns false if time between emails has not passed since last email' do
      sorcery_model_property_set(:reset_password_time_between_emails, 10_000)
      user.deliver_reset_password_instructions!

      expect(user.deliver_reset_password_instructions!).to be false
    end

    it 'encrypts properly on reset' do
      user.deliver_reset_password_instructions!
      user.change_password!('blagu')

      expect(Sorcery::CryptoProviders::BCrypt.matches?(user.crypted_password, 'blagu', user.salt)).to be true
    end
  end
end
