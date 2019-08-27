# lab-utils
Utilities to aid in lab administration

## Editing the People Page on the Lab Website
Much of the HTML on [the People page of the lab website](http://darbelofflab.mit.edu/people/) is automatically generated so as to keep formatting consistent. Two files in this repository, `employees.json` and `loadEmployees.js` aid in this. The website, built in WordPress, accesses these scripts from the `gh-pages` branch of this GitHub repository.

To add employees to the page, edit `employees.json`. Editing is fairly straightforward: simply add the new lab mate as an object to the array to which they belong. For example, to add a new graduate student-worker after John Bell's entry, simply write:
```
  {
    "name":"John Bell",
    "title":"M.S. Student",
    "degrees":[
      {
        "degree":"S.B.",
        "subject":"Mechanical Engineering",
        "institution":"MIT",
        "year":2018
      }
    ],
    "research":"Actuation",
    "alias":"jhbell",
    "image":"http://darbelofflab.mit.edu/wp-content/uploads/2019/03/Headshot_edited_small_square.jpg"
    // START NEW CODE
  },
  {
    "name":"George P. Burdell",
    "title":"M.S. Student",
    "degrees":[
      {
        "degree":"B.S.",
        "subject":"Ceramic Engineering",
        "institution":"Georgia Tech",
        "year":1930
      }
    ],
    "research":"Everything",
    "alias":"gpburdell"
    // END NEW CODE
  }
],
```

Please remember to make all edits you would like to see reflected in the website in the `gh-pages` branch.

To actually change how the HTML is generated from the `employees.json` file, edit `loadEmployees.js`.

## Making Videos for the Lab Window Monitors
The four lab window monitors can each fit three 16:9 videos stacked vertically. To help generate these videos, you can use `make_video_wall.sh`. The script uses `ffmpeg` to take in three videos, stack them vertically, rotate them to display correctly on the monitors, and then resize them so that they can be played from the video wall display units. I would recommend organizing the videos such that the three videos on a given monitor have approximately the same duration. Otherwise, the shorter videos will pause on the last frame until the longest one has completed.

To use it, you'll need to install the dependency:
```
$ sudo apt install ffmpeg
```

Then, run the following command in the directory containing `make_video_wall.sh` and the input videos:
```
$ ./make_video_wall.sh in1.mp4 in2.mp4 in3.mp4 out.mp4
```
replacing `in1.mp4` through `in3.mp4` with the videos you'd like to stack together and `out.mp4` with the filename you'd like to give the output video for the monitor.
