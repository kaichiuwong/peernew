<!-- Content Header (Page header) -->
<section class="content-header">
  <div class="container-fluid">
    <div class="row mb-2">
      <div class="col-sm-6">
        <h1><?php echo $this->session->userdata('asg_header'); ?></h1>
      </div>
      <div class="col-sm-6">
        <ol class="breadcrumb float-sm-right">
          <li class="breadcrumb-item"><a href="<?php echo site_url('assignment'); ?>">Assignment List</a></li>
          <li class="breadcrumb-item"><a href="<?php echo site_url('assignment/info/'.$asg_id); ?>">Info</a></li>
          <li class="breadcrumb-item"><a href="<?php echo site_url('assignment/group/'.$asg_id); ?>">Groups</a></li>
          <li class="breadcrumb-item active">Submission</li>
        </ol>
      </div>
    </div>
  </div><!-- /.container-fluid -->
</section>

<div class="row">
  <div class="col-12">
    <?php if (!$allow_submit) :?>
    <div class="card">
      <div class="card-header bg-danger">
        <h3 class="card-title text-bold"><i class="fas fa-exclamation-triangle"></i> No Assignment Group Found.</h3>
      </div>
      <!-- /.card-header -->
      <div class="card-body">
            You need to select an assignment group before submit any assignment.
      </div>
      <!-- /.card-body -->
    </div>
    <!-- /.card -->
    <?php else: ?>
    <div class="card card-secondary">
        <div class="card-header">
            <h3 class="card-title"><span class="badge badge-success">Part A</span> Submission</h3>
        </div>
        <!-- /.card-header -->
        <div class="card-body">
            <ul class="nav nav-tabs" id="custom-content-above-tab" role="tablist">
              <li class="nav-item">
                <a class="nav-link active" id="submission-info-tab" data-toggle="pill" href="#submission-info" role="tab" aria-controls="submission-info" aria-selected="true"><i class="fas fa-file-upload"></i> Upload Assignment</a>
              </li>
              <li class="nav-item">
                <a class="nav-link" id="history-info-tab" data-toggle="pill" href="#history-info" role="tab" aria-controls="history-info" aria-selected="false"><i class="fas fa-history"></i> Submission History</a>
              </li>
            </ul>
            <div class="tab-content" id="custom-content-above-tabContent">
              <div class="tab-pane fade show active" id="submission-info" role="tabpanel" aria-labelledby="submission-info-tab">
                <?php echo form_open_multipart('assignment/submit/'.$asg_id); ?>
                  <div class="form-group">
                    <input type="hidden" value="<?php echo $asg_id; ?>" name="asg_id" />
                    <input type="hidden" value="<?php echo $assignment_topic['topic_id']; ?>" name="grp_id" />
                    <input type="hidden" value="<?php echo $username; ?>" name="username" />
                    <label for="assignment_file">Upload Assignment File</label>
                    <div class="input-group">
                      <div class="custom-file">
                        <input type="file" class="custom-file-input" id="assignment_file" name="assignment_file" required>
                        <label class="custom-file-label" for="assignment_file"><i class="fas fa-search"></i> Choose file</label>
                      </div>
                      <div class="input-group-append">
                        <button type="submit" class="input-group-text" id=""><i class="fas fa-file-upload"></i> Upload</button>
                      </div>
                    </div>
                  </div>
                <?php echo form_close(); ?>
                <?php if ($submission_hist) { $hist = $submission_hist[0]; ?>
                <h6 class="text-bold">Submitted Assignment</h6>
                <table class="table table-sm table-head-fixed table-hover">
                    <thead>
                        <tr>
                            <th>File</th>
                            <th>Submitted by</th>
                            <th>Submission Time</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td><i class="fas fa-file"></i> <a href="<?php echo base_url().$hist->filename; ?>" target="_blank"><?php echo basename($hist->filename); ?></a></td>
                            <td><i class="fas fa-user"></i> <?php echo $hist->user_id; ?></td>
                            <td><i class="fas fa-clock"></i> <?php echo $hist->submission_date; ?></td>
                        </tr>                  
                    </tbody>
                </table>
                <?php } ?>
              </div>
              <div class="tab-pane fade" id="history-info" role="tabpanel" aria-labelledby="history-info-tab">
                    <table class="table table-sm table-head-fixed table-hover">
                        <thead>
                            <tr>
                                <th>File</th>
                                <th>Submit by</th>
                                <th>Submission Time</th>
                            </tr>
                        </thead>
                        <tbody>
                          <?php if ($submission_hist) { ?>
                            <?php foreach ($submission_hist as $hist) {?>
                                <tr>
                                    <td><i class="fas fa-file"></i> <a href="<?php echo base_url().$hist->filename; ?>" target="_blank"><?php echo basename($hist->filename); ?></a></td>
                                    <td><i class="fas fa-user"></i> <?php echo $hist->user_id; ?></td>
                                    <td><i class="fas fa-clock"></i> <?php echo $hist->submission_date; ?></td>
                                </tr>
                            <?php } ?>
                          <?php } else { ?>
                                <tr>
                                </tr>
                          <?php } ?>
                        </tbody>
                    </table>
              </div>
            </div>
        </div>
        <!-- /.card-body -->
    </div>
    <!-- /.card -->
    
    <div class="card card-secondary">
        <div class="card-header">
            <h3 class="card-title"><span class="badge badge-success">Part B</span> Self Evaluation Questions</h3>
        </div>
        <!-- /.card-header -->
        <div class="card-body">
          <table class="table table-sm table-head-fixed table-hover">
              <thead>
                  <tr>
                      <th>No.</th>
                      <th style="width: 50%">Question</th>
                      <th style="width: 40%">Answer</th>
                  </tr>
              </thead>
              <tbody>
                  <?php foreach($assignment_questions_self as $a){ ?>
                  <tr>
                      <td><span class="text-bold">Q<?php echo $a['question_order'];?>.</span></td>
                      <td class="text-justify"><?php echo $a['question']; ?></td>
                      <?php switch ($a['answer_type']):
                            case "SCALE": ?>
                          <td>
                              <select name="<?php $a['id']; ?>"  class="form-control" required>
                                <option value="" disabled selected>-- Select --</option>
                                <option value="4">4 - Always</option>
                                <option value="3">3 - Nearly Always</option>
                                <option value="2">2 - Usually</option>
                                <option value="1">1 - Sometimes</option>
                                <option value="0">0 - Seldom</option>
                              </select>
                          </td>
                        <?php break; ?>
                        <?php case "GRADE": ?>
                          <td>
                              <select name="<?php $a['id']; ?>"  class="form-control" required>
                                <option value="" disabled selected>-- Select --</option>
                                <option value="HD">HD</option>
                                <option value="DN">DN</option>
                                <option value="CR">CR</option>
                                <option value="PP">PP</option>
                                <option value="NN">NN</option>
                              </select>
                          </td>
                        <?php break; ?>
                        <?php case "SCORE": ?>
                          <td>
                              <input type="number" min="0" max="100" step="1" value=""  name="<?php $a['id']; ?>" class="form-control" required/>
                          </td>
                        <?php break; ?>
                        <?php default: ?>
                          <td>
                              <input type="text" name="<?php $a['id']; ?>" class="form-control" required/>
                          </td>
                        <?php break; ?>
                      <?php endswitch; ?>
                  </tr>
                  <?php } ?>
              </tbody>
          </table>
        </div>
        <!-- /.card-body -->
    </div>
    <!-- /.card -->
    
    <?php if (sizeof($assignment_topics_member) > 1) : ?>
    <div class="card card-secondary">
        <div class="card-header">
            <h3 class="card-title"><span class="badge badge-success">Part C</span> Peer Review</h3>
        </div>
        <!-- /.card-header -->
        <div class="card-body">
            <table class="table table-sm table-head-fixed table-hover">
              <thead>
                  <tr>
                      <th>No.</th>
                      <th style="width: 50%">Question</th>
                      <?php foreach($assignment_topics_member as $member) : ?>
                        <?php if ($member['user_id'] != $username) :?>
                          <th><?php echo $member['first_name']; ?> <?php echo $member['last_name']; ?></th>
                        <?php endif; ?>
                      <?php endforeach; ?>
                  </tr>
              </thead>
              <tbody>
                  <?php foreach($assignment_questions_peer as $a):  ?>
                  <tr>
                      <td><span class="text-bold">Q<?php echo $a['question_order'];?>.</span></td>
                      <td class="text-justify"><?php echo $a['question']; ?></td>
                      <?php foreach($assignment_topics_member as $member):  ?>
                        <?php if ($member['user_id'] != $username) :?>
                          <?php switch ($a['answer_type']):
                                case "SCALE": ?>
                              <td>
                                  <select name="<?php echo 'answer_'.$member['user_id'].'_'.$a['id']; ?>"  class="form-control" data-username="<?php echo $member['user_id']; ?>" required>
                                    <option value="" disabled selected>-- Select --</option>
                                    <option value="4">4 - Always</option>
                                    <option value="3">3 - Nearly Always</option>
                                    <option value="2">2 - Usually</option>
                                    <option value="1">1 - Sometimes</option>
                                    <option value="0">0 - Seldom</option>
                                  </select>
                              </td>
                            <?php break; ?>
                            <?php case "GRADE": ?>
                              <td>
                                  <select name="<?php echo 'answer_'.$member['user_id'].'_'.$a['id']; ?>"  class="form-control <?php echo 'grade_'.$member['user_id']; ?>" required>
                                    <option value="" disabled selected>-- Select --</option>
                                    <option value="HD">HD</option>
                                    <option value="DN">DN</option>
                                    <option value="CR">CR</option>
                                    <option value="PP">PP</option>
                                    <option value="NN">NN</option>
                                  </select>
                              </td>
                            <?php break; ?>
                            <?php case "SCORE": ?>
                              <td>
                                  <input type="number" min="0" max="100" step="1" value=""  name="<?php echo 'answer_'.$member['user_id'].'_'.$a['id']; ?>" class="form-control" data-username="<?php echo $member['user_id']; ?>" required/>
                              </td>
                            <?php break; ?>
                            <?php default: ?>
                              <td>
                                  <input type="text" name="<?php echo 'answer_'.$member['user_id'].'_'.$a['id']; ?>" class="form-control" required/>
                              </td>
                            <?php break; ?>
                           <?php endswitch; ?>
                         <?php endif; ?>
                       <?php endforeach; ?>
                  </tr>
                  <?php endforeach; ?>
                </tbody>
                <tfoot>
                  <tr>
                      <td></td>
                      <td class="text-bold">Total</td>
                      <?php foreach($assignment_topics_member as $member): ?>
                        <?php if ($member['user_id'] != $username) :?>
                          <td class="text-bold" id="sum_<?php echo $member['user_id']; ?>">0</td>
                        <?php endif; ?>
                      <?php endforeach; ?>
                  </tr>
                </tfoot>
          </table>
        </div>
        <!-- /.card-body -->
    </div>
    <!-- /.card -->
    <?php endif; ?>
    <?php endif; ?>
  </div>
</div>
<!-- /.row -->