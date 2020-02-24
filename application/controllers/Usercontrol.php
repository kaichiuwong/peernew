<?php
defined('BASEPATH') OR exit('No direct script access allowed');


Class Usercontrol extends CI_Controller {

    public function __construct() {
        parent::__construct();
        // Load database
        $this->load->model('User');
    }

    // Show login page
    public function index() {
        $this->load->view('login');
    }

    // Check for user login process
    public function login($lock = false) {
        $data = array();
        if (isset($_POST['username'])) {
            $this->form_validation->set_rules('username', 'Username', 'trim|required');
            $this->form_validation->set_rules('password', 'Password', 'trim|required');

            if ($this->form_validation->run() == FALSE) {
                $this->load->view('login', $data);
            } else {
                $username = $this->input->post('username');
                $password = $this->input->post('password');
                $result = $this->User->getUserInfo($username);
                if (!empty($result)) {
                    $orgsalt = $result[0]->salt;
                    $orgpass = $result[0]->password;
                    $locked = $result[0]->locked;
                    $challenge = crypt($password,$orgsalt);
                    
                    if ($locked == 0) {
                        if (hash_equals($orgpass,$challenge)) {
                            $session_data = array(
                                'loggedin_time' => time(),
                                'last_active_time' => time(),
                                'username' => $result[0]->username,
                                'first_name' => $result[0]->first_name,
                                'last_name' => $result[0]->last_name,
                                'stud_id' => $result[0]->id,
                                'email' => $result[0]->email,
                                'permission_level' => $result[0]->permission_level
                            );
                            $this->User->updateSuccessLogin($username);
                            $this->session->set_userdata('logged_in', $session_data);
                            redirect('Home');
                        }
                        else {
                            $this->User->updateFailCnt($username, $result[0]->login_fail_cnt);
                            $data['error_message'] = 'Invalid Username or Password';
                            $this->load->view('login', $data);
                        }
                    }
                    else {
                        $data['error_message'] = 'Account locked by the system. Please contact System Administrator to unlock your account.';
                        $this->load->view('login', $data);
                    }
                }
                else {
                    $data['error_message'] = 'Invalid Username or Password';
                    $this->load->view('login', $data);
                }
            }
        }
        else {
            $sess_array = array(
                'username' => ''
            );
            $this->session->unset_userdata('logged_in', $sess_array);
            if (!empty($lock)) {
                $data['error_message'] = 'Account locked by your administrator. Please contact System Administrator to unlock your account.';
            }
            $this->load->view('login',$data);
        }
    }

    // Logout from admin page
    public function logout() {
        $sess_array = array(
            'username' => ''
        );
        $this->session->unset_userdata('logged_in', $sess_array);
        $data['message_display'] = 'Successfully Logout';
        redirect('Usercontrol');
    }
    
    public function forgotpassword($error = false) {
        $data['errorMsg']='';
        if ($error) {
            $data['errorMsg']='Email not found from the system.';
        }
        $this->load->view('forgot-password',$data);
    }
    
    public function resetpassword($code = '') {
        $data['code']=$code;
        $data['errorMsg']='';
        if (isset($_POST['email'])) {
            $email = $_POST['email'];
            $result = $this->User->getUserInfoByEmail($email);
            if ($result) {
                $resetcode = $this->User->generateResetCode($email);
                $reseturl='http://'.$_SERVER['SERVER_NAME'] . dirname($_SERVER['REQUEST_URI']) . '/resetpassword/' . $resetcode;
                $body="<p>Dear User,</p>" ;
                $body .="<p>Your password recovery code is $resetcode. Please enter this code on the webpage using your browser or click the <a href='$reseturl'>link</a> to reset your password.</p>";
                $this->email->from('utas.ict.group@gmail.com', SYSTEM_FRIENDLY_NAME);
                $this->email->to($email);
                $this->email->subject(SYSTEM_FRIENDLY_NAME .' - Password Reset Code');
                $this->email->message($body);
                //Send mail
                if($this->email->send()) {
                    $data['infoMsg'] = "Reset code has already sent to $email. Please check your inbox for the reset code.";
                    $this->load->view('reset-password', $data);
                }
                else {
                    $this->forgotpassword(true);
                }
            }
            else {
                $this->forgotpassword(true);
            }
        }
        else if (isset($_POST['resetcode']) && isset($_POST['password'])) {
            $newpassword=$this->input->post('password');
            $reset_code=$this->input->post('resetcode');
            $result = $this->User->getUserInfoByResetCode($reset_code);
            if ($result) {
                $this->User->resetpassword($newpassword, $reset_code);
                $data['info_message'] = "Password reset complete. Please login with new password.";
                $this->load->view('login',$data);
            }
            else {
                $data['errorMsg']='Reset Code not found from system. Please request reset code again.';
                $this->load->view('reset-password',$data);
            }
        }
        else {
            $this->load->view('reset-password',$data);
        }
    }

}