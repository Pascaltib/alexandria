// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"

// for graph
import "chartkick/chart.js"

Rails.start()
Turbolinks.start()
ActiveStorage.start()


// ----------------------------------------------------
// Note(lewagon): ABOVE IS RAILS DEFAULT CONFIGURATION
// WRITE YOUR OWN JS STARTING FROM HERE 👇
// ----------------------------------------------------

// External imports
import "stylesheets/application";

// Internal imports, e.g:
// import { initSelect2 } from '../components/init_select2';
import { modalButtons } from '../components/modal_button';
import { initFlatpickr } from "../plugins/flatpickr";
import { navbarButton } from "../components/navbar"
import { congratsBalloons } from "../components/balloons"


document.addEventListener('turbolinks:load', () => {
  // Call your functions here, e.g:
  // initSelect2();
  modalButtons();
  initFlatpickr();
  navbarButton();
  congratsBalloons();
});
