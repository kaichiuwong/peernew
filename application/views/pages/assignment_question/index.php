<!-- Content Header (Page header) -->
<section class="content-header">
  <div class="container-fluid">
    <div class="row mb-2">
      <div class="col-sm-6">
        <h1><?php echo $this->session->userdata('asg_header'); ?></h1>
      </div>
      <div class="col-sm-6">
        <ol class="breadcrumb float-sm-right">
          <li class="breadcrumb-item"><a href="<?php echo site_url('Assignmentadmin'); ?>">Assignment List</a></li>
          <li class="breadcrumb-item"><a href="<?php echo site_url('Assignmentadmin/edit/'.$asg_id); ?>">Edit Info</a></li>
          <li class="breadcrumb-item"><a href="<?php echo site_url('Assignment_topic/edit/'.$asg_id); ?>">Group List</a></li>
          <li class="breadcrumb-item"><a href="<?php echo site_url('student_list/index/'.$asg_id); ?>">Student List</a></li>
          <li class="breadcrumb-item <?php echo $type=="self"?"active":"" ;?>"><a href="<?php echo site_url('assignment_question/index/'.$asg_id).'/self'; ?>">Self Evaluation</a></li>
          <li class="breadcrumb-item <?php echo $type=="peer"?"active":"" ;?>"><a href="<?php echo site_url('assignment_question/index/'.$asg_id).'/peer'; ?>">Peer Review</a></li>
        </ol>
      </div>
    </div>
  </div><!-- /.container-fluid -->
</section>


<div class="row">
  <div class="col-12">
    <div class="card card-secondary">
      <div class="card-header">
        <h3 class="card-title">Evaluation Questions</h3>
      </div>
      <!-- /.card-header -->
      <div class="card-body table-responsive-sm p-3">
      <div class="input-group">
            <?php echo form_open('assignment_question/copy_question/'); ?>
            <span class="input-group-btn">
                <a href="<?php echo site_url('assignment_question/add/'.$asg_id.'/'.$type); ?>" class="btn btn-success btn-sm">Create Questions</a>
                <a href="<?php echo site_url('assignment_question/remove_all/'.$asg_id.'/'.$type); ?>" class="btn btn-danger btn-sm">Clear Questions</a>
            </span>
            <select name="from_id" class="form-control-sm" required>
                <option value="" disabled selected>*** Copy questions from other assignment ***</option>
                <?php foreach($all_assignments as $asg){ ?>
                  <option value="<?php echo $asg['id']; ?>" ><?php echo $asg['unit_code']; ?> - <?php echo $asg['title']; ?></option>
                <?php } ?>
            </select>
            <span class="input-group-btn">
                <button class="btn btn-primary btn-sm" type="submit" tabindex="-1">Copy Question</button>
                <input type="hidden" value="<?php echo $asg_id; ?>" name="to_id" />
                <input type="hidden" value="<?php echo $type; ?>" name="question_section" />
            </span>
            <?php echo form_close(); ?>
      </div>
        <table class="table table-sm table-head-fixed table-hover enable-datatable">
            <thead>
                <tr>
                    <th>Order</th>
                    <th style="width: 60%">Question</th>
                    <th>Answer Type</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <?php foreach($assignment_questions as $a){ ?>
                <tr>
                    <td><?php echo $a['question_order']; ?></td>
                    <td><?php echo $a['question']; ?></td>
                    <td><?php echo $a['answer_type']; ?></td>
                    <td>
                        <a href="<?php echo site_url('assignment_question/edit/'.$asg_id.'/'.$type.'/'.$a['id']); ?>" class="btn btn-info btn-sm">Edit</a> 
                        <a href="<?php echo site_url('assignment_question/remove/'.$asg_id.'/'.$type.'/'.$a['id']); ?>" class="btn btn-danger btn-sm">Delete</a>
                    </td>
                </tr>
                <?php } ?>
            </tbody>
        </table>
      </div>
      <!-- /.card-body -->
    </div>
    <!-- /.card -->
  </div>
</div>
<!-- /.row -->
