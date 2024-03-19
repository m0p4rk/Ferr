package com.warr.ferr.controller;

import org.springframework.data.repository.CrudRepository;

import com.warr.ferr.model.Schedule;

public interface ScheduleRepository extends CrudRepository<Schedule, Long> {
}