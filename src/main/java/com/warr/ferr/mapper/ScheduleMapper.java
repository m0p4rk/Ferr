package com.warr.ferr.mapper;

import java.util.List;
import java.util.Map;

import com.warr.ferr.model.Schedule;

public interface ScheduleMapper {

	void saveSchedule(Schedule schedule);

	Map<String, Double> getLatitudeAndLongitude(String condition);



}
