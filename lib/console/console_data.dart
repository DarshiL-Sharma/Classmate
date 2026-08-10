import 'package:flutter/material.dart';
import 'console_widget/leaves_list.dart';
import 'console_widget/promo_carousel.dart';
import 'console_widget/up_next_list.dart';
import 'console_widget/pulse_list.dart';

class ConsoleData {
  // 1. CAROUSEL CONTENT (Images or .mp4 Videos)
  static final List<PromoEvent> events = [
    PromoEvent(title: 'Coming soon', subtitle: 'The ultimate hackathon.', img: 'assets/images/exciting comming soon.jpg'),
    PromoEvent(title: 'Utsav Fest', subtitle: 'Join the grand celebration.', img: 'assets/images/dance.jpg'),
    PromoEvent(title: 'Tech Workshop', subtitle: 'AI session.', img: 'assets/images/poster.jpg'),
    PromoEvent(title: 'Photoshoot', subtitle: 'Show your athletic side.', img: 'assets/images/film.jpg'),
    PromoEvent(title: 'Campus Talk', subtitle: 'Life in the campus.', img: 'assets/images/Campus tour Flyer.jpg'),
    PromoEvent(title: 'Campus Talk', subtitle: 'Life in the campus.', img: 'assets/images/Workshop Announcement Poster.jpg'),
  ];

  // 2. ACADEMIC MILESTONES (Exams, Results, etc.)
  static final List<UpNextItem> upNext = [
    UpNextItem(
      title: 'Instruction begins',
      meta: '6 Jul 2026',
      icon: Icons.play_circle_outline_rounded,
      url: '',
    ),
    UpNextItem(
      title: 'Mid Semester Test I',
      meta: '10 – 12 Sep 2026',
      icon: Icons.edit_note_rounded,
      url: '',
    ),
    UpNextItem(
      title: 'Mid Semester Test II',
      meta: '2 – 4 Nov 2026',
      icon: Icons.edit_note_rounded,
      url: '',
    ),
    UpNextItem(
      title: 'End Semester Exam (Theory)',
      meta: '17 – 30 Nov 2026',
      icon: Icons.school_rounded,
      url: '',
    ),
    UpNextItem(
      title: 'End Semester Exam (Practical)',
      meta: '1 – 5 Dec 2026',
      icon: Icons.science_rounded,
      url: '',
    ),
    UpNextItem(
      title: 'Declaration of Results',
      meta: '10 Dec 2026',
      icon: Icons.grade_rounded,
      url: '',
    ),
  ];

  // 3. UPCOMING LEAVES & HOLIDAYS
  static final List<LeaveRange> leaves = [
    LeaveRange(title: 'Kargil Diwas', dateRange: '26 Jul 2026', days: 1),
    LeaveRange(title: "Teachers' Day", dateRange: '5 Sep 2026', days: 1),
    LeaveRange(title: 'Hindi Diwas', dateRange: '14 Sep 2026', days: 1),
    LeaveRange(title: "Engineers' Day", dateRange: '15 Sep 2026', days: 1),
    LeaveRange(title: 'World Ozone Day', dateRange: '16 Sep 2026', days: 1),
    LeaveRange(title: 'Foundation Day', dateRange: '23 Sep 2026', days: 1),
    LeaveRange(title: 'Gandhi Jayanti', dateRange: '2 Oct 2026', days: 1),
    LeaveRange(title: 'World Natural Disaster Reduction Day', dateRange: '13 Oct 2026', days: 1),
    LeaveRange(title: 'Diwali Holidays', dateRange: '6 – 10 Nov 2026', days: 5),
    LeaveRange(title: 'Vijay Diwas', dateRange: '16 Dec 2026', days: 1),
  ];

  // 4. COMMUNITY PULSE (News Feed)
  static final List<PulseItem> pulse = [
    PulseItem(
      author: 'CR · CSE 2nd Yr',
      text: 'Timetable for next week is updated, check Notes & Docs.',
      time: '2h',
      url: 'https://example.edu/notices/timetable-update',
    ),
    PulseItem(
      author: 'Utsav Fest Team',
      text: 'Volunteer form closes Sunday night — apply now.',
      time: '5h',
      url: 'https://example.edu/events/utsav-fest-volunteer',
    ),
    PulseItem(
      author: 'Placement Cell',
      text: 'Pre-placement talk scheduled for Friday, 3 PM.',
      time: '1d',
      url: 'https://example.edu/placements/pre-placement-talk',
    ),
  ];
}
