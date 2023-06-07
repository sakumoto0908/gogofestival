ActiveAdmin.register User do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :name, :email, :password_digest, :avatar
  #
  # or
  #
  # permit_params do
  #   permitted = [:name, :email, :password_digest, :avatar]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  
  form do |f|
    f.inputs  do
      f.input :name
      f.select :age
      f.input :email
    f.inputs do
      f.has_many :images , allow_destroy: true do|t|
        t.input :image, as: file, input_html: { accept: 'image/*' },
                        :hint => t.object.new_record? ? "プロフィール画像を指定して下さい" : image_tag(t.object.image.url{:thumb})
      end
    end
    f.actions
    end
  end
end
