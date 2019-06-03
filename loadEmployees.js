var html = generateHeader('Research Staff') + startTable();
for (let e=0; e<research_staff.length; e++) {
	html += generateRow(e, research_staff[e], false);
}
html += endTable();
document.getElementById('research-staff').innerHTML = html;

html = generateHeader('Graduate Student-Workers') + startTable();
for (let e=0; e<grad_student_workers.length; e++) {
	html += generateRow(e, grad_student_workers[e], false);
}
html += endTable();
document.getElementById('graduate-student-workers').innerHTML = html;

html = generateHeader('Visiting Engineers') + startTable();
for (let e=0; e<visiting_engineers.length; e++) {
	html += generateRow(e, visiting_engineers[e], false);
}
html += endTable();
document.getElementById('visiting-engineers').innerHTML = html;

html = generateHeader('Undergraduate Researchers') + startTable();
for (let e=0; e<urops.length; e++) {
	html += generateRow(e, urops[e], true);
}
html += endTable();
document.getElementById('undergraduate-researchers').innerHTML = html;

html = generateHeader('Lab Alumni') + startTable();
for (let e=0; e<alumni.length; e++) {
	html += generateRow(e, alumni[e], true);
}
html += endTable();
document.getElementById('lab-alumni').innerHTML = html;





function generateHeader(title) {
	return '<h1 style="text-align: center;">' + title + '</h1><hr />'
}

function startTable() {
	return '\t<table id="tablepress-1" class="tablepress tablepress-id-1">\n' + 
				 '\t\t<tbody>\n';
}

function startRow(rowNum) {
	return '\t\t\t<tr class="row-' + rowNum + '">\n';
}

function imageCell(imageURL) {
	return '\t\t\t\t<td class="column-1" style="vertical-align: middle;"><img class="aligncenter size-medium" src="' + imageURL + '" alt="" width="200" /></td>\n'
}

function startContentCell() {
	return '\t\t\t\t<td class="column-2" style="vertical-align: middle;">\n';
}

function endCellAndRow() {
	return '</td>\n\t\t\t</tr>\n';
}

function endTable() {
	return '\t\t</tbody>\n\t</table>'
}

function generateRow(ind, employee, formatTight=false) {
	var html = startRow(ind);

	// Image
	if (employee.hasOwnProperty('image')) {
		html += imageCell(employee.image);
	} else {
		html += imageCell('https://cdn2.iconfinder.com/data/icons/lightly-icons/30/user-480.png');
	}

	// Name and Title
	html += startContentCell();
	html += '\t\t\t\t\t<h2>';
	if (employee.hasOwnProperty('title')) {
		html += '<strong>' + employee.name + '</strong> <em>' + employee.title + '</em>'
	} else {
		html += employee.name;
	}
	html += '</h2>\n';

	// Degrees
	if (employee.hasOwnProperty('degrees')) {
		html += '\t\t\t\t\t';
		if (formatTight) {
			html += '<em>';
		}
		html += employee.degrees.replace('\n','\n\t\t\t\t\t');
		if (formatTight) {
			html += '</em>\n';
		}
		html += '\n';
	}

	// Research Topic and Mentor
	if (employee.hasOwnProperty('mentor')) {
		var mentor = null;
		for (let e=0; e<grad_student_workers.length; e++) {
			if (grad_student_workers[e].name===employee.mentor) {
				html += '\t\t\t\t\t<strong>Research Topic:</strong> ' + grad_student_workers[e].research + '\n';
				if (formatTight) {
					html += '\n';
				}
				break;
			}
		}
		html += '\t\t\t\t\t<strong>Research Mentor:</strong> ' + employee.mentor + '\n';
	} else if (employee.hasOwnProperty('research')) {
		html += '\t\t\t\t\t<strong>Research Topic:</strong> ' + employee.research + '\n';
		if (formatTight) {
			html += '\n';
		}
	}

	// Email
	if (employee.hasOwnProperty('alias')) {
		html += '\t\t\t\t\t<strong>Email:</strong> ' + employee.alias +  '@mit.edu\n';
	}

	// End Cell and Row
	html += endCellAndRow();

	return html;
}