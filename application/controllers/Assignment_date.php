<?php
 
class Assignment_date extends MY_PasController{
    function __construct()
    {
        parent::__construct();
        $this->load->model('Assignment_date_model');
    } 

    function index($asg_id)
    {
        $done = false;

        do 
        {
            if (!$this->check_permission(30) ) break;
            $asg_result = $this->assignment_check($asg_id, false);
            if (!$asg_result['result']) break;
            $decode_asg_id = $asg_result['decode_asg_id'];
            $data['assignment'] = $asg_result['asg_info'];
            $data['asg_header'] = $asg_result['asg_header'];

            $data['asg_id'] = $asg_id;
            $data['_view'] = 'pages/assignment_date/index';
            $data['Assignment_dates'] = $this->Assignment_date_model->get_all_dates_by_asg_id($asg_id);
            $this->load_header($data);
            $this->load->view('templates/main',$data);
            $this->load_footer($data);
            $done = true;
        } while(0);

        if (!$done) redirect("Assignmentadmin");
    }

    function edit($asg_id,$id)
    {
        $done = false;

        do 
        {
            if (!$this->check_permission(30) ) break;
            $asg_result = $this->assignment_check($asg_id, false);
            if (!$asg_result['result']) break;
            $decode_asg_id = $asg_result['decode_asg_id'];
            $data['assignment'] = $asg_result['asg_info'];
            $data['asg_header'] = $asg_result['asg_header'];

            $data['asg_id'] = $asg_id;
            $data['Assignment_date'] = $this->Assignment_date_model->get_assignment_date($id);
            $current_key = $data['Assignment_date']['key'];
            $data['pair_key'] = $current_key;
            $data['pair_date'] = '';
            if (strpos($current_key, '_OPEN') !== false) {
                $data['pair_key'] = str_replace("_OPEN","_CLOSE",$current_key);
            }
            if (strpos($current_key, '_CLOSE') !== false) {
                $data['pair_key'] = str_replace("_CLOSE","_OPEN",$current_key);
            }
            if ($current_key != $data['pair_key']) {
                $data['pair_date'] = $this->Assignment_date_model->get_date_by_asg_id_key($asg_id,$data['pair_key'])['date_value'];
            }
            
            if(isset($data['Assignment_date']['id']))
            {
                if (isset($_POST['asg_id']) && isset($_POST['id'])) {
                    $date_value = null;
                    if (!empty($_POST['date_value'])) {
                        $date_value = $this->input->post('date_value');
                    }
                    $params = array(
                        'description' => $this->input->post('description'),
                        'date_value' => $date_value
                    );

                    $this->Assignment_date_model->update_assignment_date($id,$params,$this->get_login_user());            
                    redirect('Assignment_date/index/'.$asg_id);
                }
                else
                {
                    $data['_view'] = 'pages/assignment_date/edit';
                    $this->load_header($data);
                    $this->load->view('templates/main',$data);
                    $this->load_footer($data);
                }
            }
            $done = true;
        } while(0);

        if (!$done) redirect("Assignmentadmin");
    }
    
    function json($asg_id) 
    {
        $output_array = array();
        if ($this->check_permission(30)) {
            $asg_dates = $this->Assignment_date_model->get_all_dates_by_asg_id($asg_id);
            foreach($asg_dates as $d) {
                $bg_color = "#d9534f";
                if ($d['date_value']) {
                    $bg_color = ((strtotime($d['date_value']) < time())) ? "#868e96" : "#5cb85c";
                }
                $element = array (
                    "title" => $d['description'],
                    "start" => $d['date_value'],
                    "end" => $d['date_value'],
                    "backgroundColor" => $bg_color,
                    "url" => site_url('assignment_date/edit/'.$asg_id.'/'.$d['id'])
                );
                $output_array[] = $element ; 
            }
        }
        echo json_encode($output_array);
    }
    
}
