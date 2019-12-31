<?php
 
class Assignment_date extends MY_PasController{
    function __construct()
    {
        parent::__construct();
        $this->load->model('Assignment_date_model');
    } 

    function index($asg_id)
    {
        if ($this->check_permission(30)) {
            if ($asg_id) {
                $data['asg_id'] = $asg_id;
                if ($this->check_permission(20)) {
                    $data['_view'] = 'pages/Assignment_date/index';
                    $data['Assignment_dates'] = $this->Assignment_date_model->get_all_dates_by_asg_id($asg_id);
                    $this->load_header($data);
                    $this->load->view('templates/main',$data);
                    $this->load_footer($data);
                }
            }
            else {
                redirect('assignmentadmin');
            }
        }
    }

    function edit($asg_id,$id)
    {   
        if ($this->check_permission(30)) {
            $data['asg_id'] = $asg_id;
            $data['Assignment_date'] = $this->Assignment_date_model->get_assignment_date($id);
            
            if(isset($data['Assignment_date']['id']))
            {
                if (isset($_POST['asg_id']) && isset($_POST['id'])) {
                    $params = array(
                        'description' => $this->input->post('description'),
                        'date_value' => $this->input->post('date_value')
                    );

                    $this->Assignment_date_model->update_assignment_date($id,$params,$this->get_login_user());            
                    redirect('Assignment_date/index/'.$asg_id);
                }
                else
                {
                    $data['_view'] = 'pages/Assignment_date/edit';
                    $this->load_header($data);
                    $this->load->view('templates/main',$data);
                    $this->load_footer($data);
                }
            }
            else
                show_error('The Assignment_date you are trying to edit does not exist.');
        }
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
