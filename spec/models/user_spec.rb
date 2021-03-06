# == Schema Information
#
# Table name: users
#
#  id                :integer          not null, primary key
#  name              :string(255)
#  email             :string(255)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  password_digest   :string(255)
#  name_pretty       :string(255)
#  remember_token    :string(255)
#  verified          :boolean
#  verification_pass :string(255)
#

require 'spec_helper'

describe User do

  before do
    @user = User.new(name_pretty: "kalmas", email: "user@example.com",
        password: "foobar", password_confirmation: "foobar")
  end

  subject { @user }
  
  it { should respond_to(:name) }
  it { should respond_to(:name_pretty) }
  it { should respond_to(:email) }
  it { should respond_to(:password_digest) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:remember_token) }
  it { should respond_to(:authenticate) }
  it { should respond_to(:verified) }
  it { should respond_to(:verification_pass) }
    
  it { should be_valid }
    
  describe "when created" do
    it "should have a name attribute that is lowercased name_pretty" do
      @user.name_pretty = "Kalmas"
      @user.name.should eq("kalmas")
    end
  end
  
  describe "when first saved" do
    before { @user.save }
    
    it "should not be verified" do
      @user.verified.should be_false
    end
    
    it "should have a verification_pass" do
      @user.verification_pass.should_not be_empty
    end
  end
  
  describe "when name_pretty is not present" do
    before { @user.name_pretty = " " }
    it { should_not be_valid }
  end
  
  describe "when name_pretty is nil" do
    before { @user.name_pretty = nil }
    it { should_not be_valid }
  end
  
  describe "when name_pretty is too long" do
    before { @user.name_pretty = "a" * 51 }
    it { should_not be_valid }
  end
  
  describe "when name_pretty format is invalid" do
    it "should be invalid" do
      names = ['kyle almas', 'kyle#']
      names.each do |invalid_name|
        @user.name_pretty = invalid_name
        @user.should_not be_valid
      end      
    end
  end
  
  describe "when name_pretty format is valid" do
    it "should be valid" do
      names = ['kyle.almas', 'KALMAS1', 'kyle_almas']
      names.each do |valid_name|
        @user.name_pretty = valid_name
        @user.should be_valid
      end      
    end
  end
  
  describe "when name is already taken" do
    before do
      user_with_same_name = @user.dup
      user_with_same_name.email = 'aDifferentEmail@gmail.com'
      user_with_same_name.name_pretty = @user.name_pretty.upcase
      user_with_same_name.save
    end

    it { should_not be_valid }
  end
  
  describe "when email is not present" do
    before { @user.email = " " }
    it { should_not be_valid }
  end
  
  describe "when email is nil" do
    before { @user.email = nil }
    it { should_not be_valid }
  end
  
  describe "when email format is invalid" do
    it "should be invalid" do
      addresses = %w[user@foo,com user_at_foo.org example.user@foo.
                     foo@bar_baz.com foo@bar+baz.com]
      addresses.each do |invalid_address|
        @user.email = invalid_address
        @user.should_not be_valid
      end      
    end
  end
  
  describe "when email format is valid" do
    it "should be valid" do
      addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
      addresses.each do |valid_address|
        @user.email = valid_address
        @user.should be_valid
      end      
    end
  end
  
  describe "when email address is already taken" do
    before do
      user_with_same_email = @user.dup
      user_with_same_email.name_pretty = 'ADifferentName'
      user_with_same_email.email = @user.email.upcase
      user_with_same_email.save
    end

    it { should_not be_valid }
  end
  
  describe "when password is not present" do
    before { @user.password = @user.password_confirmation = " " }
    it { should_not be_valid }
  end
  
  describe "when password doesn't match confirmation" do
    before { @user.password_confirmation = "mismatch" }
    it { should_not be_valid }
  end
  
  describe "when password confirmation is nil" do
    before { @user.password_confirmation = nil }
    it { should_not be_valid }
  end
  
  describe "return value of authenticate method" do
    before { @user.save }
    let(:found_user) { User.find_by_email(@user.email) }
  
    describe "with valid password" do
      it { should == found_user.authenticate(@user.password) }
    end
  
    describe "with invalid password" do
      let(:user_for_invalid_password) { found_user.authenticate("invalid") }
  
      it { should_not == user_for_invalid_password }
      specify { user_for_invalid_password.should be_false }
    end
  end
  
  describe "with a password that's too short" do
    before { @user.password = @user.password_confirmation = "a" * 5 }
    it { should be_invalid }
  end
  
  describe "remember token" do
    before { @user.save }
    its(:remember_token) { should_not be_blank }
  end
  
  
  
  
end
