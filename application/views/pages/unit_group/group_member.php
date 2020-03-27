<div class="card">
  <div class="card-body table-responsive p-3">
    <table class="table table-head-fixed table-hover">
        <thead>
            <tr>
                <th>Member Name</th>
            </tr>
        </thead>
        <tbody>
            <?php foreach($assignment_topics as $a){ ?>
            <tr>
                <td><a href="<?php echo site_url('Member/profile/'.$a['user_id']); ?>"><?php echo $a['first_name']; ?> <?php echo $a['last_name']; ?> (<?php echo $a['user_id']; ?>)</a></td>
            </tr>
            <?php } ?>
        </tbody>
    </table>
  </div>
  <!-- /.card-body -->
</div>
<!-- /.card -->
