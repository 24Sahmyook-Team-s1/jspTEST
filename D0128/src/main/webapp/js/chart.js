function createChart(e) {
  const days = document.querySelectorAll(".chart-values li");
  const tasks = document.querySelectorAll(".chart-bars li");
  const daysArray = [...days];

  tasks.forEach((el) => {
    const duration = el.dataset.duration.split("-");
    const startDay = duration[0];
    const endDay = duration[1];
    let left = 0;
    let width = 0;

    // Calculate left position
    if (startDay.endsWith("1/2")) {
      const dayName = startDay.slice(0, -3);
      const filteredArray = daysArray.filter(
        (day) => day.textContent.toLowerCase() === dayName
      );
      if (filteredArray.length) {
        left = filteredArray[0].offsetLeft + filteredArray[0].offsetWidth / 2;
      }
    } else {
      const filteredArray = daysArray.filter(
        (day) => day.textContent.toLowerCase() === startDay
      );
      if (filteredArray.length) {
        left = filteredArray[0].offsetLeft;
      }
    }

    // Calculate width
    if (endDay.endsWith("1/2")) {
      const dayName = endDay.slice(0, -3);
      const filteredArray = daysArray.filter(
        (day) => day.textContent.toLowerCase() === dayName
      );
      if (filteredArray.length) {
        width =
          filteredArray[0].offsetLeft + filteredArray[0].offsetWidth / 2 - left;
      }
    } else {
      const filteredArray = daysArray.filter(
        (day) => day.textContent.toLowerCase() === endDay
      );
      if (filteredArray.length) {
        width =
          filteredArray[0].offsetLeft + filteredArray[0].offsetWidth - left;
      }
    }

    // Apply styles
    el.style.left = `${left}px`;
    el.style.width = `${width}px`;

    if (e.type === "load") {
      el.style.backgroundColor = el.dataset.color;
      el.style.opacity = 1;
    }
  });
}

window.addEventListener("load", createChart);
window.addEventListener("resize", createChart);
