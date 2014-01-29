module Issue1566
  class App < Padrino::Application
    enable :sessions
    enable :allow_disabled_csrf

    get :index do
      response.set_cookie('CSRF-TOKEN', value: (session[:csrf] ||= SecureRandom.hex(32)),
                          expires: Time.now + 3600*24)

%Q[
<script src="//code.jquery.com/jquery-2.1.0.min.js"></script>
<script>
!function($) {
  $.post('/');
  $.ajax({type: 'POST', url: '/', headers: {'X-CSRF-TOKEN': '#{session[:csrf]}'}});
}(window.$);
</script>
]
    end

    post :index do
      "You're in!"
    end

    error 403 do
      "Need a valid CSRF code..."
    end
  end
end
