<?php 

class MY_PasController extends CI_Controller
{
    var $session_array;
    var $user_role;
    
    public function __construct()
    {
        parent::__construct();
        $this->session_array = $this->session->userdata('logged_in');
        $this->user_role = "public";
        if (!empty($this->session_array)) {
            $plevel = $this->session_array['permission_level'];
            switch(true) {
                case $plevel >= 90:
                    $this->user_role = "admin";
                    break;
                case $plevel >= 20:
                    $this->user_role = "staff";
                    break;
                case $plevel >= 10:
                    $this->user_role = "user";
                    break;
                default: 
                    $this->user_role = "public";
                    break;
            }
        }
    }

    public function is_session_valid()
    {
        $result = false ;
        if (isset($this->session_array)) {
            $current_time = time(); 
            if(isset($this->session_array['last_active_time']) and isset($this->session_array['username'])){  
                if(((time() - $this->session_array['last_active_time']) <= SESSION_EXPIRE_TIME)){ 
                    $this->refresh_footprint() ;
                    $result = true;
                } 
            }
        }
        return $result;
    }
    
    public function is_permitted($min_level) {
        $result = false ;
        if (isset($this->session_array)) {
            if(isset($this->session_array['permission_level'])) {
                if ($this->session_array['permission_level'] >= $min_level) {
                    $result = true;
                }
            }
        }
        return $result;
    }
    
    public function refresh_footprint() 
    {
        $session_data = array(
            'loggedin_time' => $this->session_array['loggedin_time'],
            'last_active_time' => time(),
            'username' => $this->session_array['username'],
            'first_name' => $this->session_array['first_name'],
            'last_name' => $this->session_array['last_name'],
            'stud_id' => $this->session_array['stud_id'],
            'email' => $this->session_array['email'],
            'permission_level' => $this->session_array['permission_level']
        );
        $this->session->set_userdata('logged_in', $session_data);
    }

    public function current_sem() 
    {
        return '202001';
    }
    
    public function refresh_user_session_info()
    {
        $this->load->model('User');
        $session_data = array(
            'loggedin_time' => $this->session_array['loggedin_time'],
            'last_active_time' => time(),
            'username' => $this->session_array['username'],
            'first_name' => $this->session_array['first_name'],
            'last_name' => $this->session_array['last_name'],
            'stud_id' => $this->session_array['stud_id'],
            'email' => $this->session_array['email'],
            'permission_level' => $this->session_array['permission_level']
        );
        $result = $this->User->getUserInfo($this->session_array['username']);
        if (!empty($result)) {
            $session_data = array(
                'loggedin_time' => $this->session_array['loggedin_time'],
                'last_active_time' => time(),
                'username' => $this->session_array['username'],
                'first_name' => $result[0]->first_name,
                'last_name' => $result[0]->last_name,
                'stud_id' => $result[0]->id,
                'email' => $result[0]->email,
                'permission_level' => $result[0]->permission_level
            );
        }
        $this->session->set_userdata('logged_in', $session_data);
    }
    
    public function check_permission($min_level, $redirect = true) {
        
        if (!$this->is_session_valid()) {
            if ($redirect) {
                redirect('Usercontrol');
            }
            return false;
        }
        else {
            if (!$this->is_permitted($min_level)) {
                if ($redirect) {
                    $this->load_header();
                    $data['_view'] = 'pages/deny';
                    $this->load->view('templates/main',$data);
                    $this->load_footer();
                }
                return false;
            }
        }
        return true;
    }
    
    public function is_allow_view_asg($asg_id) {
        $this->load->model('Assignment_model');
        $result = $this->Assignment_model->is_allow_view_assignment($this->get_login_user(), $asg_id);
        if (!$result) {
            $this->load_header();
            $data['_view'] = 'pages/deny_asg';
            $this->load->view('templates/main',$data);
            $this->load_footer();
        }
        return $result;
    }

    public function is_open($asg_id, $open_key, $close_key, $display_error_page = true)
    {
        $this->load->model('Assignment_date_model');
        $result = false;
        $open_date = $this->Assignment_date_model->get_date_by_asg_id_key($asg_id, $open_key);
        $close_date = $this->Assignment_date_model->get_date_by_asg_id_key($asg_id, $close_key);
        $current_time = time();
        $open = null;
        $close = null ;
        $open_desc = "";
        $close_desc = "";
        if ($open_date && $close_date) {
            $open = $open_date['date_value'];
            $close = $close_date['date_value'];
            $open_desc = $open_date['description'];
            $close_desc = $close_date['description'];
            
            if ($open  && $close) 
            {
                if ( ( $current_time >= strtotime($open) ) && $current_time <= strtotime($close) ) 
                {
                    $result = true;
                }
            }
            else if ($open)
            {
                if ( ( $current_time >= strtotime($open) ) ) 
                {
                    $result = true;
                }
            }
            else if ($close)
            {
                if ( $current_time <= strtotime($close) ) 
                {
                    $result = true;
                }
            }
        }

        if (!$result && $display_error_page) {
            $this->load->view('pages/expire');
        }

        return array("result" => $result, "open_date" => $open, "close_date" => $close, "open_desc" => $open_desc, "close_desc" => $close_desc);
    }
    
    public function get_login_user() {
        $user = '';
        if (isset($this->session_array)) {
            $user = $this->session_array['username'];
        }
        return $user;
    }
    
    public function get_login_username() {
        $user = '';
        if (isset($this->session_array)) {
            $user = $this->session_array['first_name'] . ' ' . $this->session_array['last_name'];
        }
        return $user;
    }
    
    public function load_header($data = array()) {
        $data['user'] = $this->get_login_username();
        $this->load->view('templates/'.$this->user_role.'-header', $data);
        $this->load->view('templates/topbar', $data);
        $this->load->view('templates/'.$this->user_role.'-sidebar', $data);
    }

    public function load_assignment_header($id = null, $data = array()) {
        if ($id) {
            $data['asg_id'] = $id;
            $data['unit_list'] = $this->Unit->get_list();
            $data['unit_code'] = '';
            $data['unit_desc'] = '';
            $data['title']='';
            $assign_info = $this->Assignment->get_info($id);
            if ($assign_info) {
                $data['title']=$assign_info[0]->title;
                $data['outcome']=$assign_info[0]->outcome;
                $data['scenario']=$assign_info[0]->scenario;
                $data['type']=$assign_info[0]->type;
                $data['unit_id']=$assign_info[0]->unit_id;
                $data['deadlines'] = $this->Assignment->get_deadline($id);
                $unit_info = $this->Unit->get_unit_info($assign_info[0]->unit_id);
                if ($unit_info) {
                    $data['unit_code'] = $unit_info[0]->unit_code;
                    $data['unit_desc'] = $unit_info[0]->unit_description;
                }
                $data['user'] = $this->get_login_username();
                $this->load->view('templates/'.$this->user_role.'-header', $data);
                $this->load->view('templates/assign-topbar', $data);
            }
            else {
                $this->load_header($data);
            }
        }
        else {
            $this->load_header($data);
        }
    }
    
    public function load_footer($data = array()) {
        $this->load->view('templates/'.$this->user_role.'-footer', $data);
    }

}