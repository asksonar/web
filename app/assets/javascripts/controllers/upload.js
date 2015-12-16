$(function(){
  if ($('#upload-index').length === 0) {
    return;
  }

  Papa.LocalChunkSize = 1048576; // cut it down from 10MB to 1MB for processing

  function processEntireFile(file) {
    Papa.parse(file, {
      header: true,
      skipEmptyLines: true,
      chunk: function(results, file) {
        $.ajax({
          type: 'POST',
          url: '/settings/upload',
          data: {
            authenticity_token: AUTH_TOKEN,
            metadata: Papa.unparse(results.data)
          },
          success: function() {
            $('.progress-bar').width($('.progress-bar').width() + 80);
            $('.status').addClass('bg-success').text('File was processed successfully.');
          },
          error: function(jqXHR) {
            $('.status').addClass('bg-danger').text(jqXHR.responseText);
          }
        });
      },
      complete: function(results, file) {
        // finished processing the whole file
      },
      error: function(error, file) {
        errorWithFile("There was an error reading your file: " + error);
      }
    });
  }

  function errorWithFile(errorMessage, errorRows) {
    $('.status').addClass('bg-danger').text(errorMessage);
  }

  function clearStatus() {
    $('.status').removeClass('bg-danger').removeClass('bg-success').text('');
  }

  function testBeginningOfFile(evt) {
    clearStatus();

    var file = evt.target.files[0];
    if (file === undefined) {
      return;
    }

    // first check the file
    Papa.parse(file, {
      header: true,
      skipEmptyLines: true,
      preview: 10,
      complete: function(results) {
        var indexOfEmail = results.meta.fields.indexOf('email');
        if (indexOfEmail >= 0) {
          processEntireFile(file);
        } else {
            errorWithFile("Please make sure that there is a column named \"email\" in the CSV. ");
        }
      },
      error: function(error, file) {
        errorWithFile("There was an error reading your file: " + error);
      }
    });
  }

  $('#file').on('change', testBeginningOfFile);
});
